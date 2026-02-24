import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

/// Reusable profil avatarı — profil resmi + premium doğrulanmış rozet
/// Tüm ekranlarda kullanılır (profil, home, stk, becayiş, chat)
class ProfileAvatar extends ConsumerWidget {
  final double radius;
  final bool showPremiumBadge;
  final VoidCallback? onTap;
  final bool showCameraButton;

  const ProfileAvatar({
    super.key,
    this.radius = 40,
    this.showPremiumBadge = true,
    this.onTap,
    this.showCameraButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profil = ref.watch(profilProvider);
    final imagePath = profil.profileImagePath;
    final name = profil.name ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'K';
    final isPremium = profil.isPremium;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badgeSize = radius * 0.4;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width:
            radius * 2 + (showPremiumBadge && isPremium ? badgeSize * 0.3 : 0),
        height:
            radius * 2 + (showPremiumBadge && isPremium ? badgeSize * 0.3 : 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar
            Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: imagePath == null ? AppTheme.primaryGradient : null,
                image:
                    imagePath != null && File(imagePath).existsSync()
                        ? DecorationImage(
                          image: FileImage(File(imagePath)),
                          fit: BoxFit.cover,
                        )
                        : null,
                border: Border.all(
                  color:
                      isPremium && showPremiumBadge
                          ? const Color(0xFF1DA1F2)
                          : (isDark ? Colors.white12 : Colors.grey.shade200),
                  width: isPremium && showPremiumBadge ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isPremium && showPremiumBadge
                            ? const Color(0xFF1DA1F2).withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
                  imagePath == null || !File(imagePath).existsSync()
                      ? Center(
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: radius * 0.7,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                      : null,
            ),

            // Premium doğrulanmış rozet ✓
            if (showPremiumBadge && isPremium)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DA1F2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppTheme.surfaceDark : Colors.white,
                      width: badgeSize * 0.12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1DA1F2).withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: badgeSize * 0.6,
                  ),
                ),
              ),

            // Kamera butonu (profil ekranı için)
            if (showCameraButton)
              Positioned(
                bottom: showPremiumBadge && isPremium ? badgeSize * 0.4 : 0,
                right: showPremiumBadge && isPremium ? badgeSize * 0.8 : 0,
                child: Container(
                  padding: EdgeInsets.all(radius * 0.12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppTheme.surfaceDark : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: radius * 0.3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
