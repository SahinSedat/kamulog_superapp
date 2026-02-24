import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Bildirim Ayarlari ekrani — bildirim izinleri + bildirim listesi
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _smsConsent = false;
  bool _emailConsent = false;
  bool _notificationGranted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPreferences();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _smsConsent = prefs.getBool('smsConsent') ?? false;
      _emailConsent = prefs.getBool('emailConsent') ?? false;
    });
    final status = await Permission.notification.status;
    setState(() => _notificationGranted = status.isGranted);
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    setState(() => _notificationGranted = status.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final notifications = _sampleNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Bildirim Ayarlari'),
            Tab(text: 'Bildirimler'),
          ],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          indicatorColor: AppTheme.primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── Tab 1: Bildirim Ayarlari
          _buildNotificationSettings(isDark),

          // ── Tab 2: Bildirim Listesi
          _buildNotificationList(notifications, isDark),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
    List<_NotificationItem> notifications,
    bool isDark,
  ) {
    if (notifications.isEmpty) {
      return Center(
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
              'Henuz bildirim yok',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifications.length,
      separatorBuilder:
          (_, __) =>
              Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
      itemBuilder: (context, index) {
        final n = notifications[index];
        return _NotificationTile(notification: n, isDark: isDark);
      },
    );
  }

  Widget _buildNotificationSettings(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bildirim Izni (Cihaz)
          _SettingsCard(
            icon: Icons.notifications_active_rounded,
            title: 'Bildirim Izni',
            description:
                'Becayis eslesmeleri, duyurular ve kampanya bildirimlerini alin.',
            isButton: true,
            granted: _notificationGranted,
            onRequest: _requestNotificationPermission,
            color: const Color(0xFF1565C0),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // SMS Bildirimi
          _SettingsCard(
            icon: Icons.sms_rounded,
            title: 'SMS Bildirimleri',
            description:
                'Onemli bildirimler ve dogrulama kodlari SMS ile gonderilsin.',
            isToggle: true,
            value: _smsConsent,
            onChanged: (v) async {
              setState(() => _smsConsent = v);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('smsConsent', v);
            },
            color: const Color(0xFF2E7D32),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // E-posta Bildirimi
          _SettingsCard(
            icon: Icons.email_rounded,
            title: 'E-posta Bildirimleri',
            description:
                'Guncellemeler, kampanyalar ve duyurular e-posta ile gonderilsin.',
            isToggle: true,
            value: _emailConsent,
            onChanged: (v) async {
              setState(() => _emailConsent = v);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('emailConsent', v);
            },
            color: const Color(0xFFE65100),
            isDark: isDark,
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.infoColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.infoColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: AppTheme.infoColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bildirim tercihleriniz cihazinizda ve veritabaninda kaydedilir.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.infoColor.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bildirim Ayarlari Karti
class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool isDark;
  final bool isToggle;
  final bool isButton;
  final bool value;
  final bool granted;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onRequest;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.isDark,
    this.isToggle = false,
    this.isButton = false,
    this.value = false,
    this.granted = false,
    this.onChanged,
    this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
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
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isToggle)
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: color,
            ),
          if (isButton)
            granted
                ? Icon(Icons.check_circle_rounded, color: color, size: 28)
                : SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Izin Ver',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ── Bildirim Listesi Tile
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
        onTap: () {},
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
    title: 'Becayis Eslesmesi!',
    body: 'Istanbul \u2192 Ankara becayis ilanina uygun bir eslesme bulundu.',
    timeAgo: '5 dk once',
    icon: Icons.swap_horiz_rounded,
    color: Color(0xFF2E7D32),
  ),
  _NotificationItem(
    title: 'Yeni Duyuru',
    body:
        'Milli Egitim Bakanligi yeni personel alimi hakkinda duyuru yayinladi.',
    timeAgo: '1 saat once',
    icon: Icons.campaign_rounded,
    color: Color(0xFF1565C0),
  ),
  _NotificationItem(
    title: 'AI Analiz Sonucu',
    body: 'CV analiz raporunuz hazir. Becayis uyum puaniniz: 87/100.',
    timeAgo: '3 saat once',
    icon: Icons.auto_awesome,
    color: Color(0xFF7B1FA2),
    isRead: true,
  ),
  _NotificationItem(
    title: 'Danismanlik Yaniti',
    body: 'Hukuk danismaniniz mesajiniza yanit verdi.',
    timeAgo: '5 saat once',
    icon: Icons.support_agent_rounded,
    color: Color(0xFFE65100),
    isRead: true,
  ),
  _NotificationItem(
    title: 'Uyelik Hatirlatma',
    body: 'Premium uyeliginizin suresi 7 gun icinde dolacak.',
    timeAgo: '1 gun once',
    icon: Icons.card_membership_rounded,
    color: Color(0xFFC62828),
    isRead: true,
  ),
];
