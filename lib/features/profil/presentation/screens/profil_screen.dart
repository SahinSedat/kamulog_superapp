import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';

/// Gelişmiş Profil Ekranı — kullanıcı bilgileri, üyelik, satın alımlar, çıkış
class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profilim'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // ── Avatar & Name
            _ProfileHeader(user: user, isDark: isDark),
            const SizedBox(height: 24),

            // ── Profil Tamamlama Uyarısı
            if (_isProfileIncomplete(user))
              _ProfileCompletionBanner(
                onTap: () => context.push('/profile/edit'),
              ),

            // ── Üyelik Durumu
            _SectionHeader(title: 'Üyelik & Abonelik'),
            _MembershipCard(isDark: isDark),

            // ── Kişisel Bilgiler
            _SectionHeader(title: 'Kişisel Bilgiler'),
            _InfoMenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.person_outline,
                  title: 'Ad Soyad',
                  trailing: user?.name ?? 'Belirtilmedi',
                  onTap: () => context.push('/profile/edit'),
                ),
                _MenuItem(
                  icon: Icons.phone_outlined,
                  title: 'Telefon',
                  trailing: user?.phone ?? '',
                  onTap: null,
                ),
                _MenuItem(
                  icon: Icons.badge_outlined,
                  title: 'TC Kimlik No',
                  trailing: 'Girilmedi',
                  onTap: () => context.push('/profile/edit'),
                  showWarning: true,
                ),
                _MenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Adres Bilgileri',
                  trailing: 'Girilmedi',
                  onTap: () => context.push('/profile/edit'),
                  showWarning: true,
                ),
              ],
              isDark: isDark,
            ),

            // ── Çalışma Bilgileri
            _SectionHeader(title: 'Çalışma Bilgileri'),
            _InfoMenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.account_balance_outlined,
                  title: 'Çalışma Durumu',
                  trailing: _employmentTypeText(user?.employmentType),
                  onTap: () => context.push('/profile/edit'),
                ),
                _MenuItem(
                  icon: Icons.business_outlined,
                  title: 'Kurum',
                  trailing: 'Belirtilmedi',
                  onTap: () => context.push('/profile/edit'),
                ),
                _MenuItem(
                  icon: Icons.work_outline,
                  title: 'Unvan',
                  trailing: user?.title ?? 'Belirtilmedi',
                  onTap: () => context.push('/profile/edit'),
                ),
              ],
              isDark: isDark,
            ),

            // ── Satın Alımlar
            _SectionHeader(title: 'Satın Alımlarım'),
            _InfoMenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Ürünler & Siparişler',
                  trailing: '0 sipariş',
                  onTap: () => context.push('/orders'),
                ),
                _MenuItem(
                  icon: Icons.card_membership_outlined,
                  title: 'Üyelik Geçmişi',
                  trailing: 'Görüntüle',
                  onTap: () => context.push('/orders'),
                ),
              ],
              isDark: isDark,
            ),

            // ── Ayarlar
            _SectionHeader(title: 'Ayarlar'),
            _InfoMenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Bildirim Ayarları',
                  onTap: () => context.push('/notifications'),
                ),
                _MenuItem(
                  icon: Icons.lock_outline,
                  title: 'Gizlilik & Güvenlik',
                  onTap: () => context.push('/permissions'),
                ),
                _MenuItem(
                  icon: Icons.help_outline,
                  title: 'Yardım & Destek',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Yardım merkezi yakında aktif olacak'),
                      ),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  title: 'Hakkında',
                  trailing: 'v1.0.0',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Kamulog',
                      applicationVersion: 'v1.0.0',
                      applicationLegalese:
                          '© 2026 Kamulog. Tüm hakları saklıdır.',
                    );
                  },
                ),
              ],
              isDark: isDark,
            ),

            const SizedBox(height: 16),
            // ── Çıkış Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context, ref),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.errorColor,
                  ),
                  label: const Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.errorColor.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  bool _isProfileIncomplete(dynamic user) {
    if (user == null) return true;
    return user.name == null || user.name!.isEmpty;
  }

  String _employmentTypeText(dynamic type) {
    if (type == null) return 'Belirtilmedi';
    return type.toString().split('.').last == 'memur'
        ? 'Devlet Memuru'
        : type.toString().split('.').last == 'isci'
        ? 'Kamu İşçisi'
        : 'Sözleşmeli';
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Çıkış Yap'),
            content: const Text(
              'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ref.read(authProvider.notifier).logout();
                  context.go('/login');
                },
                child: const Text(
                  'Çıkış Yap',
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

// ── Profile Header
class _ProfileHeader extends StatelessWidget {
  final dynamic user;
  final bool isDark;
  const _ProfileHeader({required this.user, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'Kullanıcı';
    final phone = user?.phone ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'K';

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(phone, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
      ],
    );
  }
}

// ── Profile Completion Banner
class _ProfileCompletionBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _ProfileCompletionBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.warningColor.withValues(alpha: 0.1),
              AppTheme.warningColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.warningColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppTheme.warningColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profilinizi Tamamlayın',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'TC Kimlik ve adres bilgileriniz olmadan becayiş, STK ve CV özelliklerini kullanamazsınız.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.warningColor,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Membership Card
class _MembershipCard extends StatelessWidget {
  final bool isDark;
  const _MembershipCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ücretsiz Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Premium\'a yükselterek tüm özelliklere erişin',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Yükselt',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ── Info Menu Group
class _InfoMenuGroup extends StatelessWidget {
  final List<_MenuItem> items;
  final bool isDark;

  const _InfoMenuGroup({required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFEEEEEE),
        ),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                leading: Icon(
                  item.icon,
                  size: 22,
                  color: AppTheme.primaryColor,
                ),
                title: Row(
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.showWarning) ...[
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.trailing != null)
                      Text(
                        item.trailing!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    if (item.onTap != null) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    ],
                  ],
                ),
                onTap: item.onTap,
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: 50,
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;
  final bool showWarning;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showWarning = false,
  });
}
