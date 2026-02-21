import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Gizlilik & Güvenlik — Bildirim ve iletişim izinleri
/// KVKK ve Kamera kaldırıldı
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _smsConsent = false;
  bool _emailConsent = false;
  bool _notificationGranted = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Gizlilik & Güvenlik'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bildirim İzni (Cihaz)
            _PermissionCard(
              icon: Icons.notifications_active_rounded,
              title: 'Bildirim İzni',
              description:
                  'Becayiş eşleşmeleri, duyurular ve kampanya bildirimlerini alın.',
              isButton: true,
              granted: _notificationGranted,
              onRequest: _requestNotificationPermission,
              color: const Color(0xFF1565C0),
            ),
            const SizedBox(height: 12),

            // SMS Bildirimi
            _PermissionCard(
              icon: Icons.sms_rounded,
              title: 'SMS Bildirimleri',
              description:
                  'Önemli bildirimler ve doğrulama kodları SMS ile gönderilsin.',
              isToggle: true,
              value: _smsConsent,
              onChanged: (v) async {
                setState(() => _smsConsent = v);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('smsConsent', v);
              },
              color: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 12),

            // E-posta Bildirimi
            _PermissionCard(
              icon: Icons.email_rounded,
              title: 'E-posta Bildirimleri',
              description:
                  'Güncellemeler, kampanyalar ve duyurular e-posta ile gönderilsin.',
              isToggle: true,
              value: _emailConsent,
              onChanged: (v) async {
                setState(() => _emailConsent = v);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('emailConsent', v);
              },
              color: const Color(0xFFE65100),
            ),

            const SizedBox(height: 24),
            // Gizlilik politikası bölümü
            const Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Gizlilik & Politikalar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _PolicyTile(
              icon: Icons.article_outlined,
              title: 'Gizlilik Politikası',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gizlilik politikası yakında eklenecek'),
                  ),
                );
              },
            ),
            _PolicyTile(
              icon: Icons.description_outlined,
              title: 'Kullanım Koşulları',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kullanım koşulları yakında eklenecek'),
                  ),
                );
              },
            ),
            _PolicyTile(
              icon: Icons.cookie_outlined,
              title: 'Çerez Politikası',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Çerez politikası yakında eklenecek'),
                  ),
                );
              },
            ),
            _PolicyTile(
              icon: Icons.delete_outline,
              title: 'Hesabımı Sil',
              isDestructive: true,
              onTap: () => _showDeleteAccountDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    setState(() => _notificationGranted = status.isGranted);
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Hesabı Sil'),
            content: const Text(
              'Hesabınızı silmek istediğinize emin misiniz?\nBu işlem geri alınamaz ve tüm verileriniz silinir.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hesap silme talebi gönderildi'),
                    ),
                  );
                },
                child: const Text(
                  'Hesabımı Sil',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool isToggle;
  final bool isButton;
  final bool value;
  final bool granted;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onRequest;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
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
                      'İzin Ver',
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

class _PolicyTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _PolicyTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = isDestructive ? AppTheme.errorColor : Colors.grey[700];
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 20, color: tileColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: tileColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}
