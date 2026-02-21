/// Kamu kurumları listesi — sabit veri
/// Web yönetim panelinden güncellenebilir, şimdilik statik
class PublicInstitutions {
  static const List<String> institutions = [
    // Bakanlıklar
    'Adalet Bakanlığı',
    'Aile ve Sosyal Hizmetler Bakanlığı',
    'Çalışma ve Sosyal Güvenlik Bakanlığı',
    'Çevre, Şehircilik ve İklim Değişikliği Bakanlığı',
    'Dışişleri Bakanlığı',
    'Enerji ve Tabii Kaynaklar Bakanlığı',
    'Gençlik ve Spor Bakanlığı',
    'Hazine ve Maliye Bakanlığı',
    'İçişleri Bakanlığı',
    'Kültür ve Turizm Bakanlığı',
    'Milli Eğitim Bakanlığı',
    'Milli Savunma Bakanlığı',
    'Sağlık Bakanlığı',
    'Sanayi ve Teknoloji Bakanlığı',
    'Tarım ve Orman Bakanlığı',
    'Ticaret Bakanlığı',
    'Ulaştırma ve Altyapı Bakanlığı',

    // Cumhurbaşkanlığı
    'Cumhurbaşkanlığı',
    'Cumhurbaşkanlığı İletişim Başkanlığı',
    'Cumhurbaşkanlığı Strateji ve Bütçe Başkanlığı',
    'Devlet Denetleme Kurulu',
    'Diyanet İşleri Başkanlığı',

    // Yargı
    'Anayasa Mahkemesi',
    'Yargıtay',
    'Danıştay',
    'Sayıştay',
    'Hakimler ve Savcılar Kurulu',

    // Bağımsız Kurumlar
    'Bankacılık Düzenleme ve Denetleme Kurumu',
    'Bilgi Teknolojileri ve İletişim Kurumu',
    'Enerji Piyasası Düzenleme Kurumu',
    'Kamu İhale Kurumu',
    'Kişisel Verileri Koruma Kurumu',
    'Radyo ve Televizyon Üst Kurulu',
    'Rekabet Kurumu',
    'Sermaye Piyasası Kurulu',
    'Sosyal Güvenlik Kurumu',
    'Türkiye İstatistik Kurumu',

    // Üniversiteler (örnek)
    'İstanbul Üniversitesi',
    'Ankara Üniversitesi',
    'Hacettepe Üniversitesi',
    'Orta Doğu Teknik Üniversitesi',
    'Boğaziçi Üniversitesi',
    'İstanbul Teknik Üniversitesi',
    'Ege Üniversitesi',
    'Gazi Üniversitesi',
    'Dokuz Eylül Üniversitesi',
    'Marmara Üniversitesi',

    // Diğer
    'Belediyeler (Büyükşehir)',
    'Belediyeler (İlçe)',
    'İl Özel İdaresi',
    'Kaymakamlık',
    'Valilik',
    'Emniyet Genel Müdürlüğü',
    'Jandarma Genel Komutanlığı',
    'Sahil Güvenlik Komutanlığı',
    'Orman Genel Müdürlüğü',
    'Devlet Su İşleri Genel Müdürlüğü',
    'Karayolları Genel Müdürlüğü',
    'Tapu ve Kadastro Genel Müdürlüğü',
    'Meteoroloji Genel Müdürlüğü',
    'Nüfus ve Vatandaşlık İşleri Genel Müdürlüğü',
    'Türkiye İş Kurumu (İŞKUR)',
    'PTT',
    'TCDD',
    'THY',
    'TRT',
    'Anadolu Ajansı',

    // Kamu Bankaları
    'Ziraat Bankası',
    'Halkbank',
    'Vakıfbank',
    'İller Bankası',

    // Diğer Kamu Kurumları
    'Diğer',
  ];

  /// Kurumları arama filtresi ile döndür
  static List<String> search(String query) {
    if (query.isEmpty) return institutions;
    final q = query.toLowerCase();
    return institutions.where((i) => i.toLowerCase().contains(q)).toList();
  }
}
