import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Ürünler & Siparişler ekranı
/// Ayrı modül: features/orders/ — ileride ayrı DB entegrasyonu
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Ürünler & Siparişler'),
        centerTitle: true,
      ),
      body:
          _sampleOrders.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _sampleOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _OrderCard(
                    order: _sampleOrders[index],
                    isDark: isDark,
                  );
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Henüz siparişiniz yok',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mağazadan alışveriş yaptığınızda\nsiparişleriniz burada görünecek.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _Order order;
  final bool isDark;
  const _OrderCard({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst satır: sipariş no + durum
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sipariş #${order.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: order.statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.statusText,
                  style: TextStyle(
                    color: order.statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Ürün bilgisi
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: order.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(order.icon, color: order.color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Alt satır: tarih + fiyat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    order.date,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
              Text(
                order.price,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Order {
  final String id;
  final String title;
  final String description;
  final String date;
  final String price;
  final String statusText;
  final Color statusColor;
  final IconData icon;
  final Color color;

  const _Order({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.price,
    required this.statusText,
    required this.statusColor,
    required this.icon,
    required this.color,
  });
}

const _sampleOrders = [
  _Order(
    id: '1042',
    title: 'Premium Üyelik — 1 Yıl',
    description: 'Tüm özelliklere sınırsız erişim',
    date: '20 Şub 2026',
    price: '₺299,99',
    statusText: 'Aktif',
    statusColor: Color(0xFF2E7D32),
    icon: Icons.star_rounded,
    color: Color(0xFFE65100),
  ),
  _Order(
    id: '1035',
    title: 'CV Oluşturucu Pro',
    description: 'AI destekli profesyonel CV şablonları',
    date: '15 Şub 2026',
    price: '₺49,99',
    statusText: 'Tamamlandı',
    statusColor: Color(0xFF1565C0),
    icon: Icons.description_rounded,
    color: Color(0xFF1565C0),
  ),
  _Order(
    id: '1028',
    title: 'Hukuk Danışmanlığı — 3 Seans',
    description: 'İdare hukuku uzmanı ile online görüşme',
    date: '10 Şub 2026',
    price: '₺250,00',
    statusText: 'Tamamlandı',
    statusColor: Color(0xFF7B1FA2),
    icon: Icons.gavel_rounded,
    color: Color(0xFF7B1FA2),
  ),
];
