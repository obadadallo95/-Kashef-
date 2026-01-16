import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'logger_service.dart';

class OCRService {
  final LogService _logger;
  // Note: On-device ML Kit Text Recognition primarily supports Latin-based languages.
  // Arabic support is limited/unavailable in the standard on-device v2 model.
  // However, we implement this as requested to capture any recognizable text.
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  OCRService(this._logger);

  Future<String> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      if (recognizedText.text.trim().isNotEmpty) {
        _logger.info('OCR Extracted ${recognizedText.text.length} characters');
        return recognizedText.text;
      }
      return '';
    } catch (e, stack) {
      _logger.error('OCR Failed', e, stack);
      return '';
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
