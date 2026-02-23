class ProfanityFilterService {
  // Demo amaçlı temel argo ve küfür listesi.
  // Gerçek uygulamada veritabanından çekilebilir veya daha geniş bir kütüphane kullanılabilir.
  static const List<String> _badWords = [
    'amk',
    'aq',
    'amq',
    'siktir',
    'orospu',
    'pic',
    'piç',
    'yavsak',
    'yavşak',
    'kahpe',
    'ibne',
    'gavat',
    'pezevenk',
    'sürtük',
    'salak',
    'mal',
    'aptal',
    'geri zekalı',
    'gerizekalı',
  ];

  /// Metnin içerisinde filtrelenen kelimelerden biri var mı kontrol eder.
  static bool hasProfanity(String text) {
    final lowerText = text.toLowerCase();

    for (final word in _badWords) {
      // Kelime bazlı basit bir arama (Daha gelişmiş RegEx kullanılabilir)
      if (lowerText.contains(word)) {
        return true;
      }
    }
    return false;
  }

  /// Eğer istenirse mesajdaki kötü kelimeleri sansürleyebilir.
  static String censorString(String text) {
    String censoredText = text;
    for (final word in _badWords) {
      final regExp = RegExp(word, caseSensitive: false);
      censoredText = censoredText.replaceAll(regExp, '*' * word.length);
    }
    return censoredText;
  }
}
