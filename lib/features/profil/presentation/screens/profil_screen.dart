import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/storage/local_storage_service.dart';
import 'package:kamulog_superapp/core/widgets/app_toast.dart';
import 'package:kamulog_superapp/core/widgets/profile_avatar.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

import 'package:kamulog_superapp/core/providers/home_navigation_provider.dart';

/// Gelişmiş Profil Ekranı — kullanıcı bilgileri, üyelik, satın alımlar, çıkış
class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final profil = ref.watch(profilProvider);

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

            // ── Bilgilerim (Kişisel + Çalışma birleştirildi)
            _SectionHeader(title: 'Bilgilerim'),
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
                  trailing:
                      profil.tcKimlik != null
                          ? '••• ••• ${profil.tcKimlik!.substring(profil.tcKimlik!.length > 4 ? profil.tcKimlik!.length - 4 : 0)}'
                          : 'Girilmedi',
                  onTap: () => context.push('/profile/edit'),
                  showWarning: profil.tcKimlik == null,
                ),
                _MenuItem(
                  icon: Icons.email_outlined,
                  title: 'E-posta',
                  trailing: profil.email ?? 'Girilmedi',
                  onTap: () => context.push('/profile/edit'),
                  showWarning: profil.email == null || profil.email!.isEmpty,
                ),
                _MenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Adres Bilgileri',
                  trailing: profil.addressText,
                  onTap: () => context.push('/profile/edit'),
                  showWarning: profil.city == null,
                ),
                _MenuItem(
                  icon: Icons.account_balance_outlined,
                  title: 'Çalışma Durumu',
                  trailing: profil.employmentText,
                  onTap:
                      profil.employmentType != null
                          ? null
                          : () => context.push('/profile/edit'),
                ),
                _MenuItem(
                  icon: Icons.business_outlined,
                  title: 'Kurum',
                  trailing: profil.effectiveInstitution,
                  onTap: () => context.push('/profile/edit'),
                ),
                _MenuItem(
                  icon: Icons.work_outline,
                  title: 'Unvan',
                  trailing: profil.title ?? 'Belirtilmedi',
                  onTap: () => context.push('/profile/edit'),
                ),
              ],
              isDark: isDark,
            ),

            // ── İlgi Alanlarım (Anketten)
            if (profil.surveyInterests.isNotEmpty) ...[
              _SectionHeader(title: 'İlgi Alanlarım'),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
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
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      profil.surveyInterests.map((interest) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],

            // ── Belgelerim
            _SectionHeader(title: 'Belgelerim'),
            _InfoMenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.folder_rounded,
                  title: 'Tüm Belgelerim',
                  trailing: 'CV, STK, Kimlik',
                  onTap: () => context.push('/documents'),
                ),
                _MenuItem(
                  icon: Icons.description_rounded,
                  title: 'CV Belgelerim',
                  trailing: 'Kariyer modülünde kullan',
                  onTap: () => context.push('/documents'),
                ),
              ],
              isDark: isDark,
            ),

            // ── Kariyer
            _SectionHeader(title: 'Kariyer'),
            _InfoMenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.auto_awesome_rounded,
                  title: 'AI CV Oluşturucu',
                  trailing: 'Yapay zeka ile',
                  onTap: () {
                    // CV oluşturma sadece Kariyer modülünden yapılır
                    ref.read(homeNavigationProvider.notifier).setIndex(3);
                    context.go('/');
                  },
                ),
                _MenuItem(
                  icon: Icons.analytics_rounded,
                  title: 'İş Analizi',
                  trailing: () {
                    final count = LocalStorageService.loadJobAnalyses().length;
                    return count > 0 ? '$count analiz kaydı' : 'CV eşleştirme';
                  }(),
                  onTap: () => _showAnalysisHistory(context, isDark),
                ),
              ],
              isDark: isDark,
            ),

            // ── Mesajlarım
            _SectionHeader(title: 'Mesajlarım'),
            _InfoMenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Danışman ile Canlı Sohbet',
                  trailing: 'Anında destek',
                  onTap: () => context.push('/chat'),
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
                  onTap: () => context.push('/subscription-history'),
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
            // ── Üyelik Plan Değiştirme
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/upgrade-plan'),
                  icon: Icon(
                    profil.isPremium
                        ? Icons.star_rounded
                        : Icons.workspace_premium_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    profil.isPremium
                        ? 'Premium Planınızı Yönetin'
                        : '✨ Premium Plana Geçin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        profil.isPremium
                            ? const Color(0xFF1DA1F2)
                            : AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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

  void _showAnalysisHistory(BuildContext context, bool isDark) {
    final analyses = LocalStorageService.loadJobAnalyses();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardDark : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.analytics_rounded,
                          color: AppTheme.primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'İş Analizi Geçmişi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${analyses.length} kayıt',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (analyses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Henüz iş analizi yapmadınız',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kariyer modülünden ilan analizi yapabilirsiniz',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: analyses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) {
                        final a = analyses[index];
                        final score = a['score'] as int? ?? 0;
                        final isUygun = a['isUygun'] as bool? ?? false;
                        final date = DateTime.tryParse(a['date'] ?? '');
                        final dateStr =
                            date != null
                                ? '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}'
                                : '';

                        Color scoreColor;
                        if (score >= 70) {
                          scoreColor = const Color(0xFF2E7D32);
                        } else if (score >= 40) {
                          scoreColor = const Color(0xFFF57C00);
                        } else {
                          scoreColor = const Color(0xFFD32F2F);
                        }

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isDark
                                      ? Colors.white12
                                      : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: scoreColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    '%$score',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: scoreColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a['jobTitle'] ?? 'İlan',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            isDark
                                                ? Colors.white
                                                : Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${a['company'] ?? ''} • $dateStr',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isUygun
                                          ? const Color(
                                            0xFF2E7D32,
                                          ).withValues(alpha: 0.1)
                                          : const Color(
                                            0xFFF57C00,
                                          ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isUygun ? 'Uygun' : 'Alternatif',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        isUygun
                                            ? const Color(0xFF2E7D32)
                                            : const Color(0xFFF57C00),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }
}

// ── Profile Header
class _ProfileHeader extends ConsumerWidget {
  final dynamic user;
  final bool isDark;
  const _ProfileHeader({required this.user, required this.isDark});

  Future<void> _pickAndCropImage(BuildContext context, WidgetRef ref) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      // Instagram tarzı kırpma
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Profil Fotoğrafı',
            toolbarColor: AppTheme.primaryColor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppTheme.primaryColor,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            lockAspectRatio: true,
            hideBottomControls: false,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
          IOSUiSettings(
            title: 'Profil Fotoğrafı',
            cropStyle: CropStyle.circle,
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: true,
          ),
        ],
      );
      if (croppedFile == null) return;

      // Kalıcı dizine kaydet
      final dir = await getApplicationDocumentsDirectory();
      final savedPath = '${dir.path}/profile_photo.jpg';
      await File(croppedFile.path).copy(savedPath);

      ref.read(profilProvider.notifier).updateProfileImage(savedPath);
    } catch (e) {
      if (context.mounted) {
        AppToast.error(context, 'Fotoğraf yüklenirken hata oluştu.');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = user?.name ?? 'Kullanıcı';
    final phone = user?.phone ?? '';
    final profil = ref.watch(profilProvider);

    return Column(
      children: [
        ProfileAvatar(
          radius: 44,
          showPremiumBadge: true,
          showCameraButton: true,
          onTap: () => _pickAndCropImage(context, ref),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(phone, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        const SizedBox(height: 8),

        // ── Plan Bilgisi Gösterimi
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color:
                profil.isPremium
                    ? AppTheme.accentColor.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  profil.isPremium
                      ? AppTheme.accentColor.withValues(alpha: 0.5)
                      : Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                profil.isPremium
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: 14,
                color: profil.isPremium ? AppTheme.accentColor : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                profil.isPremium ? 'Premium Plan' : 'Temel Plan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: profil.isPremium ? AppTheme.accentColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
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
                    Expanded(
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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
                      Flexible(
                        child: Text(
                          item.trailing!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
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
