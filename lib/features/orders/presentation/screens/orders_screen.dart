import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/storage/local_storage_service.dart';

/// Ürünler & Siparişler ekranı — uygulama içi satışlar ve abonelik logları
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = LocalStorageService.loadOrderRecords();

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
          orders.isEmpty
              ? _buildEmptyState(isDark)
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  // En yeni siparişi en üstte göster
                  final order = orders[orders.length - 1 - index];
                  return _OrderCard(order: order, isDark: isDark);
                },
              ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
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
            'Premium abonelik veya jeton satın aldığınızda\nsiparişleriniz burada görünecek.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<dynamic, dynamic> order;
  final bool isDark;
  const _OrderCard({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final plan = order['plan'] as String? ?? 'aylik';
    final title = order['title'] as String? ?? 'Premium Abonelik';
    final description = order['description'] as String? ?? '';
    final price = order['price'] as String? ?? '₺ 0';
    final dateStr = order['date'] as String? ?? '';
    final status = order['status'] as String? ?? 'active';

    // Plan rengini belirle
    final isYillik = plan == 'yillik';
    final planColor =
        isYillik ? const Color(0xFFD4AF37) : AppTheme.primaryColor;
    final planIcon = isYillik ? Icons.star_rounded : Icons.workspace_premium;

    // Tarihi formatla
    String formattedDate = '';
    if (dateStr.isNotEmpty) {
      final date = DateTime.tryParse(dateStr);
      if (date != null) {
        const months = [
          '',
          'Oca',
          'Şub',
          'Mar',
          'Nis',
          'May',
          'Haz',
          'Tem',
          'Ağu',
          'Eyl',
          'Eki',
          'Kas',
          'Ara',
        ];
        formattedDate = '${date.day} ${months[date.month]} ${date.year}';
      }
    }

    // Durum bilgisi
    final statusText = status == 'active' ? 'Aktif' : 'Tamamlandı';
    final statusColor =
        status == 'active' ? const Color(0xFF2E7D32) : AppTheme.primaryColor;

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
                'Sipariş #${(order['id'] as String? ?? '').substring(0, 6).toUpperCase()}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: planColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(planIcon, color: planColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
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
                    formattedDate,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          // Store bilgisi
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.store_rounded,
                size: 12,
                color: isDark ? Colors.white30 : Colors.grey.shade400,
              ),
              const SizedBox(width: 4),
              Text(
                'App Store / Play Store üzerinden',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white30 : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
