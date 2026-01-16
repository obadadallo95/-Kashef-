import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/local_filter_service.dart';
import '../../../../core/services/ocr_service.dart';
import 'package:dio/dio.dart';

// Provider for Dio
final dioProvider = Provider<Dio>((ref) => Dio());

// Provider for AIService
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService(ref.read(dioProvider), ref.read(loggerProvider));
});

final ocrServiceProvider = Provider<OCRService>((ref) {
  return OCRService(ref.read(loggerProvider));
});

// Provider for LocalFilterService
final localFilterServiceProvider = Provider<LocalFilterService>((ref) {
  return LocalFilterService();
});

// Provider for AnalysisRepository
final analysisRepositoryProvider = Provider<AnalysisRepository>((ref) {
    return AnalysisRepository(
      ref.read(aiServiceProvider),
      ref.read(localFilterServiceProvider),
      ref.read(ocrServiceProvider),
      ref.read(loggerProvider)
    );
});

class AnalysisResult {
  final int score;
  final String riskLevel;
  final List<String> reasons;
  final List<String> suggestions;
  final String? saferAlternative;
  final List<String> flaggedSegments;

  AnalysisResult({
    required this.score,
    required this.riskLevel,
    required this.reasons,
    required this.suggestions,
    this.saferAlternative,
    this.flaggedSegments = const [],
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      score: (json['score'] as num?)?.toInt() ?? 0,
      riskLevel: json['risk_level'] as String? ?? 'Unknown',
      reasons: (json['reasons'] as List?)?.map((e) => e.toString()).toList() ?? [],
      suggestions: (json['suggestions'] as List?)?.map((e) => e.toString()).toList() ?? [],
      saferAlternative: json['safer_alternative'] as String?,
      flaggedSegments: (json['flagged_segments'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class AnalysisRepository {
  final AIService _aiService;
  final LocalFilterService _localFilterService;
  final OCRService _ocrService;
  final LogService _logger;

  AnalysisRepository(this._aiService, this._localFilterService, this._ocrService, this._logger);

  Future<AnalysisResult> analyzeContent(String text, File? image) async {
    String contentToAnalyze = text;
    
    // Step 0: OCR Extraction (Blind Spot Coverage)
    if (image != null) {
      try {
        final extractedText = await _ocrService.extractText(image);
        if (extractedText.isNotEmpty) {
           _logger.info("OCR Found Text: $extractedText");
           contentToAnalyze += "\n\n[TEXT FOUND IN IMAGE]:\n$extractedText";
        }
      } catch (e) {
        _logger.warning("OCR skipped due to error");
      }
    }

    // Step 1: Local Check (Hybrid Filter)
    // The strict check is now performed in the HomeController layer for immediate blocking.
    // The repository focuses on the heavy lifting (OCR + Cloud AI).
    // We can add a secondary pass here if needed, but for now we skip to AI.

    // Step 2: AI Check (Groq)
    try {
      // Pass the combined text (Typed + OCR) to the AI
      final jsonString = await _aiService.getAnalysis(contentToAnalyze, image);
      _logger.info("Raw Analysis Response: $jsonString");

      // Clean response if it contains markdown code blocks
      String cleanJson = jsonString;
      if (cleanJson.contains('```json')) {
        cleanJson = cleanJson.replaceAll('```json', '').replaceAll('```', '');
      } else if (cleanJson.contains('```')) {
         cleanJson = cleanJson.replaceAll('```', '');
      }
      
      Map<String, dynamic> jsonMap;
      try {
        jsonMap = jsonDecode(cleanJson);
      } catch (e) {
        // Fallback: Try to repair common JSON errors (e.g., single quotes)
         _logger.warning("JSON Decode failed, attempting repair...");
        String repairedJson = cleanJson
            .replaceAll("'", '"') // Replace single quotes with double quotes (Risky but necessary for Python dicts)
            .replaceAll('None', 'null')
            .replaceAll('False', 'false')
            .replaceAll('True', 'true');
        
        // Restore apostrophes in text if possible? (This is hard, simpler to just rely on Prompt fix, but this is a last resort)
        jsonMap = jsonDecode(repairedJson);
      }
      return AnalysisResult.fromJson(jsonMap);
    } catch (e, stack) {
      _logger.error('Analysis failed', e, stack);
      // Return a safe default error object
      return AnalysisResult(
        score: 0, 
        riskLevel: 'Warning', // Changed from Error/Danger to Warning to be less alarming
        reasons: ['فشل الاتصال بالخادم'], 
        suggestions: ['تأكد من اتصال الإنترنت وحاول مرة أخرى.'],
        saferAlternative: null,
        flaggedSegments: [],
      );
    }
  }
}
