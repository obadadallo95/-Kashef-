import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/logger_service.dart';
import '../../../../core/services/local_filter_service.dart';
import '../../../analysis/data/repositories/analysis_repository.dart';

class HomeState {
  final String text;
  final File? selectedImage;
  final bool isAnalyzing;
  final AnalysisResult? result;

  const HomeState({
    this.text = '',
    this.selectedImage,
    this.isAnalyzing = false,
    this.result,
  });

  HomeState copyWith({
    String? text,
    File? selectedImage,
    bool? isAnalyzing,
    AnalysisResult? result,
  }) {
    return HomeState(
      text: text ?? this.text,
      selectedImage: selectedImage ?? this.selectedImage,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      result: result ?? this.result,
    );
  }
  
  HomeState copyWithImage(File? image) {
    return HomeState(
      text: text,
      selectedImage: image,
      isAnalyzing: isAnalyzing,
      result: result,
    );
  }
}

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(HomeController.new);

class HomeController extends Notifier<HomeState> {
  late final LogService _logger;
  late final AnalysisRepository _repository;
  final ImagePicker _picker = ImagePicker();

  @override
  HomeState build() {
    _logger = ref.read(loggerProvider);
    _repository = ref.read(analysisRepositoryProvider);
    return const HomeState();
  }

  void updateText(String text) {
    state = state.copyWith(text: text);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50, // Compress image to reduce payload size
        maxWidth: 1024,   // Limit width
      );
      if (pickedFile != null) {
        state = state.copyWithImage(File(pickedFile.path));
        _logger.info('Image picked: ${pickedFile.path}');
      }
    } catch (e, stack) {
      _logger.error('Error picking image', e, stack);
    }
  }

  void removeImage() {
    state = state.copyWithImage(null);
    _logger.info('Image removed');
  }

  DateTime? _lastRequestTime;

  Future<void> analyzeContent() async {
    if (state.text.isEmpty && state.selectedImage == null) return;

    // Rate Limiter: Prevent spamming (3 seconds cooldown)
    final now = DateTime.now();
    if (_lastRequestTime != null && now.difference(_lastRequestTime!) < const Duration(seconds: 3)) {
      _logger.info("Rate limiter active. Ignoring request.");
      // Optional: We could show a toast here via a side-effect provider, but simply ignoring is also fine for safety.
      return;
    }
    _lastRequestTime = now;

    state = state.copyWith(isAnalyzing: true);
    _logger.info('Starting analysis...');

    // ---------------------------------------------------------
    // Layer 1: Local Hybrid Filter (Instant Protection)
    // ---------------------------------------------------------
    final filterResult = LocalFilterService.checkText(state.text);

    if (filterResult.isBlocked) {
      _logger.info("Blocked locally: ${filterResult.matchedTerm}");
      // 🔴 Strict Block: Do NOT call API. Return immediately.
      state = state.copyWith(
        isAnalyzing: false,
        result: AnalysisResult(
          score: 0,
          riskLevel: 'Dangerous',
          reasons: ['تم رصد مصطلح محظور قطعياً: ${filterResult.matchedTerm}'],
          suggestions: ['نعتذر، ولكن هذا النص يحتوي على مفردات تخالف معايير المجتمع بشكل صريح ولا يمكن نشره.'],
        ),
      );
      return;
    }

    if (filterResult.needsAIReview) {
       _logger.info("Contextual Warning: ${filterResult.matchedTerm}. Proceeding to AI...");
       // 🟡 Warning: Update UI to show we are checking context, but continue to API.
       // Ideally we could show a toast here, but for now we just log it and let AI decide.
    }

    // ---------------------------------------------------------
    // Layer 2: Cloud Analysis (Contextual Logic)
    // ---------------------------------------------------------
    try {
      final result = await _repository.analyzeContent(state.text, state.selectedImage);
      
      // If locally suspicious but AI says safe, we trust AI (or mix them?)
      // Current logic: Repository returns the AI result. 
      // We could inject the local warning into the AI result if needed, 
      // but for now let's trust the AI's final judgment as it has more context.
      
      state = state.copyWith(isAnalyzing: false, result: result);
      _logger.info('Analysis completed: ${result.riskLevel}');
    } catch (e, stack) {
      _logger.error('Analysis failed in controller', e, stack);
      state = state.copyWith(isAnalyzing: false);
    }
  }

  void reset() {
    state = const HomeState();
    _logger.info('Panic Mode: State cleared.');
  }
}
