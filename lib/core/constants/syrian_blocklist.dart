import 'generated_banned_words.dart';

class SyrianBlocklist {
  // Danger words: Explicit banned organizations or hate speech
  static List<String> get dangerWords => [
    ..._manualDangerWords,
    // ...GeneratedBannedWords.list, // Disable temporary: Too aggressive (17k words causes high FPS)
  ];

  static const List<String> _manualDangerWords = [
    // Hate Speech
    "نصيري",
    "رافضي", 
    "مرتد",
    "خوارج",
    "كافر",
    
    // Banned Orgs (Examples)
    "داعش",
    "تنظيم الدولة",
    "جبهة النصرة",
    "النصرة",
    "هيئة تحرير الشام",
    "بي كي كي",
    "pkk",
    "ypg",
    "قسد",
  ];

  // Warning words: Contentious but context-dependent
  static const List<String> warningWords = [
    "اشتباك",
    "قذيفة",
    "دم",
    "قتلى",
    "شهيد",
    "نظام",
    "معارضة",
    "كيماوي",
    "مسلح",
  ];
}
