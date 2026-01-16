import '../constants/generated_banned_words.dart';

class FilterResult {
  final bool isBlocked;
  final bool needsAIReview;
  final String? matchedTerm;

  FilterResult({
    this.isBlocked = false,
    this.needsAIReview = false,
    this.matchedTerm,
  });

  bool get isSafe => !isBlocked && !needsAIReview;
}

class LocalFilterService {
  /// التطبيع: إزالة التشكيل وتوحيد الحروف لتسهيل المطابقة
  static String _normalize(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F]'), '') // إزالة التشكيل
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .toLowerCase(); // للأحرف الإنجليزية
  }

  static FilterResult checkText(String text) {
    if (text.isEmpty) return FilterResult();

    final normalizedText = _normalize(text);

    // 1. فحص القائمة الحمراء (حظر فوري)
    for (final term in SyrianBlocklist.strictBanList) {
      final normalizedTerm = _normalize(term);
      if (normalizedText.contains(normalizedTerm)) {
        return FilterResult(
          isBlocked: true,
          matchedTerm: term,
        );
      }
    }

    // 2. فحص القائمة الرمادية (تحتاج مراجعة AI)
    for (final term in SyrianBlocklist.contextualWatchlist) {
      final normalizedTerm = _normalize(term);
      if (normalizedText.contains(normalizedTerm)) {
        return FilterResult(
          needsAIReview: true,
          matchedTerm: term,
        );
      }
    }

    // 3. النص سليم محلياً
    return FilterResult();
  }
}
