import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'logger_service.dart';

import 'package:dio_smart_retry/dio_smart_retry.dart'; 

class AIService {
  final Dio _dio;
  final LogService _logger;

  AIService(this._dio, this._logger) {
    // Add Smart Retry Interceptor
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: (message) => _logger.warning('[API Retry] $message'),
      retries: 3, // Retry 3 times
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ));
    
    // Set Timeouts (30 seconds)
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  // Production: Use Cloudflare Worker URL to bypass Geo-blocking & hide API Key
  // Development: Use Direct Groq URL (requires VPN in Syria or valid IP)
  String get _baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> getAnalysis(String text, File? image) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      _logger.warning("GROQ_API_KEY is missing in .env");
    } else {
      _logger.info("GROQ_API_KEY loaded.");
    }
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GROQ_API_KEY is missing in .env');
    }

    try {
      final dynamic messageContent;
      
      if (image != null) {
        // Multimodal Request (Text + Image)
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        messageContent = [
          {
            "type": "text",
            "text": "Role: Content Safety Guardian for Syrian users.\n\nTask: Analyze text/image for Facebook/Instagram automated ban triggers (Violence, Hate, Terror Groups).\n\nInput: '$text'\n\nInstructions:\n1. Calc 'score' (0=Safe, 100=Immediate Ban).\n2. If score > 20%, you MUST generate a 'safer_alternative' that conveys the EXACT SAME MEANING but using neutral, safe language that evades algorithmic bans.\n3. Extract specific triggers into 'flagged_segments'.\n\nReturn JSON ONLY: {\"score\": int, \"risk_level\": \"Safe\"|\"Warning\"|\"Danger\", \"reasons\": [\"Arabic\"], \"suggestions\": [\"Arabic\"], \"safer_alternative\": \"Arabic text rewritten safely\", \"flagged_segments\": [\"bad word\"]}"
          },
          {
            "type": "image_url",
            "image_url": {
              "url": "data:image/jpeg;base64,$base64Image"
            }
          }
        ];
      } else {
         // Text-Only Request
         messageContent = "Role: Content Safety Guardian for Syrian users.\n\nTask: Analyze text for Facebook/Instagram automated ban triggers (Violence, Hate, Terror Groups).\n\nInput: '$text'\n\nInstructions:\n1. Calc 'score' (0=Safe, 100=Immediate Ban).\n2. If score > 20%, you MUST generate a 'safer_alternative' that conveys the EXACT SAME MEANING but using neutral, safe language that evades algorithmic bans.\n3. Extract specific triggers into 'flagged_segments'.\n\nReturn JSON ONLY: {\"score\": int, \"risk_level\": \"Safe\"|\"Warning\"|\"Danger\", \"reasons\": [\"Arabic\"], \"suggestions\": [\"Arabic\"], \"safer_alternative\": \"Arabic text rewritten safely\", \"flagged_segments\": [\"bad word\"]}";
      }

      final String selectedModel = image != null 
          ? 'llama-3.2-90b-vision-preview' 
          : 'llama-3.3-70b-versatile';

      // DEBUG: Log the request payload
      _logger.info("Sending Payload using model: $selectedModel");
      // _logger.info("Payload: ${jsonEncode(messageContent)}"); // Too verbose, uncomment if needed

      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "model": selectedModel,
          "messages": [
            {
              "role": "user",
              "content": messageContent,
            }
          ],
          "temperature": 0.0,
          "max_tokens": 1024,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final contentStr = data['choices'][0]['message']['content'] as String;
        return contentStr; // Expecting raw JSON string
      } else {
        throw Exception('Failed to analyze content: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _logger.warning("🛑 Dio Error Type: ${e.type}");
      _logger.warning("🛑 Dio Error Message: ${e.message}");
      
      if (e.response != null) {
        _logger.warning("⚠️ Server Status Code: ${e.response?.statusCode}");
        _logger.warning("⚠️ Server Error Data: ${e.response?.data}"); // CRITICAL: Log the error body
      } else {
        _logger.warning("❌ No response received from server (Network/DNS issue)");
      }

      _logger.error('Error contacting Groq API', e, e.stackTrace);
      rethrow;
    } catch (e, stack) {
      _logger.error('Unexpected error', e, stack);
      rethrow;
    }
  }
}
