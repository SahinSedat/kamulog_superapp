import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Bildirimler ekranı — web push notification entegrasyonu için hazır
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Firebase/OneSignal push notification entegrasyonu yapılacak
    final notifications = _sampleNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        actions: [
          TextButton(
            onPressed: () {
              // Tümünü okundu olarak işaretle
            },
            child: const Text('Tümünü Oku', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
      body:
          notifications.isEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Henüz bildirim yok',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: notifications.length,
                separatorBuilder:
                    (_, __) => Divider(
                      height: 1,
                      color: Colors.grey.withValues(alpha: 0.15),
                    ),
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return _NotificationTile(notification: n, isDark: isDark);
                },
              ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem notification;
  final bool isDark;

  const _NotificationTile({required this.notification, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          notification.isRead
              ? null
              : AppTheme.primaryColor.withValues(alpha: isDark ? 0.08 : 0.04),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: notification.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(notification.icon, color: notification.color, size: 22),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.body,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              notification.timeAgo,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing:
            notification.isRead
                ? null
                : Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
        onTap: () {
          // Bildirim detayına yönlendir
        },
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String body;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final bool isRead;

  const _NotificationItem({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

const _sampleNotifications = [
  _NotificationItem(
    title: 'Becayiş Eşleşmesi!',
    body: 'İstanbul → Ankara becayiş ilanınıza uygun bir eşleşme bulundu.',
    timeAgo: '5 dk önce',
    icon: Icons.swap_horiz_rounded,
    color: Color(0xFF2E7D32),
  ),
  _NotificationItem(
    title: 'Yeni Duyuru',
    body:
        'Milli Eğitim Bakanlığı yeni personel alımı hakkında duyuru yayınladı.',
    timeAgo: '1 saat önce',
    icon: Icons.campaign_rounded,
    color: Color(0xFF1565C0),
  ),
  _NotificationItem(
    title: 'AI Analiz Sonucu',
    body: 'CV analiz raporunuz hazır. Becayiş uyum puanınız: 87/100.',
    timeAgo: '3 saat önce',
    icon: Icons.auto_awesome,
    color: Color(0xFF7B1FA2),
    isRead: true,
  ),
  _NotificationItem(
    title: 'Danışmanlık Yanıtı',
    body: 'Hukuk danışmanınız mesajınıza yanıt verdi.',
    timeAgo: '5 saat önce',
    icon: Icons.support_agent_rounded,
    color: Color(0xFFE65100),
    isRead: true,
  ),
  _NotificationItem(
    title: 'Üyelik Hatırlatma',
    body: 'Premium üyeliğinizin süresi 7 gün içinde dolacak.',
    timeAgo: '1 gün önce',
    icon: Icons.card_membership_rounded,
    color: Color(0xFFC62828),
    isRead: true,
  ),
];
