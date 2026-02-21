import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Kayıt sonrası izin isteme ekranı
/// SMS, Email, Kamera, Kişisel Veri izinleri
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _smsConsent = false;
  bool _emailConsent = false;
  bool _personalDataConsent = false;
  bool _cameraGranted = false;
  bool _notificationGranted = false;

  @override
  Widget build(BuildContext context) {
    final allRequired = _personalDataConsent;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'İzinler & Onaylar',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Uygulamanın düzgün çalışabilmesi için aşağıdaki izinlere ihtiyacımız var.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              Expanded(
                child: ListView(
                  children: [
                    // ── Zorunlu: Kişisel Verilerin Kullanımı
                    _PermissionCard(
                      icon: Icons.security_rounded,
                      title: 'Kişisel Verilerin Korunması (KVKK)',
                      description:
                          'Kişisel verileriniz 6698 sayılı KVKK kapsamında işlenmektedir. Bu izni onaylamanız zorunludur.',
                      isToggle: true,
                      value: _personalDataConsent,
                      onChanged:
                          (v) => setState(() => _personalDataConsent = v),
                      required: true,
                      color: const Color(0xFFC62828),
                    ),
                    const SizedBox(height: 12),

                    // ── Bildirim İzni (Cihaz)
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

                    // ── SMS Bildirimi
                    _PermissionCard(
                      icon: Icons.sms_rounded,
                      title: 'SMS Bildirimleri',
                      description:
                          'Önemli bildirimler ve doğrulama kodları SMS ile gönderilsin.',
                      isToggle: true,
                      value: _smsConsent,
                      onChanged: (v) => setState(() => _smsConsent = v),
                      color: const Color(0xFF2E7D32),
                    ),
                    const SizedBox(height: 12),

                    // ── E-posta Bildirimi
                    _PermissionCard(
                      icon: Icons.email_rounded,
                      title: 'E-posta Bildirimleri',
                      description:
                          'Güncellemeler, kampanyalar ve duyurular e-posta ile gönderilsin.',
                      isToggle: true,
                      value: _emailConsent,
                      onChanged: (v) => setState(() => _emailConsent = v),
                      color: const Color(0xFFE65100),
                    ),
                    const SizedBox(height: 12),

                    // ── Kamera İzni
                    _PermissionCard(
                      icon: Icons.camera_alt_rounded,
                      title: 'Kamera İzni',
                      description:
                          'Profil fotoğrafı ve belge tarama için kamera erişimi gereklidir.',
                      isButton: true,
                      granted: _cameraGranted,
                      onRequest: _requestCameraPermission,
                      color: const Color(0xFF7B1FA2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // ── Devam Et Butonu
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: allRequired ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Devam Et',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'KVKK onayı zorunludur. Diğer izinler isteğe bağlıdır.',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    setState(() => _notificationGranted = status.isGranted);
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() => _cameraGranted = status.isGranted);
  }

  Future<void> _continue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('smsConsent', _smsConsent);
    await prefs.setBool('emailConsent', _emailConsent);
    await prefs.setBool('personalDataConsent', _personalDataConsent);
    await prefs.setBool('permissionsCompleted', true);

    if (mounted) {
      context.go('/');
    }
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
  final bool required;
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
    this.required = false,
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
        border: Border.all(
          color:
              required && !value
                  ? AppTheme.errorColor.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.12),
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (required) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Zorunlu',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
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
