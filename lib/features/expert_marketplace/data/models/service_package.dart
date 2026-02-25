/// Hizmet paketi — uzmanın sunduğu danışmanlık hizmetleri
class ServicePackage {
  final String id;
  final String name;
  final String description;
  final double price; // 0 = Ücretsiz
  final String duration; // "15 dk", "30 dk", "60 dk"
  final String? iapProductId; // Store product ID (ileride kullanılacak)
  final bool isPremium;
  final List<String> includes; // Paketin içerikleri

  const ServicePackage({
    required this.id,
    required this.name,
    required this.description,
    this.price = 0,
    this.duration = '15 dk',
    this.iapProductId,
    this.isPremium = false,
    this.includes = const [],
  });

  bool get isFree => price == 0;

  String get priceLabel {
    if (isFree) return 'Ücretsiz';
    return '₺${price.toStringAsFixed(price == price.roundToDouble() ? 0 : 2)}';
  }
}
