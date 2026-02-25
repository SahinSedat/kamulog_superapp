import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_profile.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/providers/expert_marketplace_provider.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/widgets/service_package_card.dart';

/// Uzman Detay — profil, paketler, yorumlar, "Hemen Danış" CTA
class ExpertDetailScreen extends ConsumerStatefulWidget {
  final String expertId;
  const ExpertDetailScreen({super.key, required this.expertId});

  @override
  ConsumerState<ExpertDetailScreen> createState() => _ExpertDetailScreenState();
}

class _ExpertDetailScreenState extends ConsumerState<ExpertDetailScreen> {
  String? _selectedPackageId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifier = ref.read(expertMarketplaceProvider.notifier);
    final expert = notifier.getExpertById(widget.expertId);

    if (expert == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Uzman bulunamadı')),
      );
    }

    final catInfo = expert.categoryInfo;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Uzman Profili'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profil Header
                _buildProfileHeader(expert, catInfo, isDark),

                // ── Biyografi
                _buildSection(
                  title: 'Hakkında',
                  isDark: isDark,
                  child: Text(
                    expert.bio,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),

                // ── Uzmanlık Alanları
                _buildSection(
                  title: 'Uzmanlık Alanları',
                  isDark: isDark,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        expert.specializations.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: catInfo.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: catInfo.color.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: catInfo.color,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),

                // ── Hizmet Paketleri
                _buildSection(
                  title: 'Hizmet Paketleri',
                  isDark: isDark,
                  child: Column(
                    children:
                        expert.packages.map((pkg) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ServicePackageCard(
                              package: pkg,
                              isDark: isDark,
                              isSelected: _selectedPackageId == pkg.id,
                              onTap:
                                  () => setState(
                                    () => _selectedPackageId = pkg.id,
                                  ),
                            ),
                          );
                        }).toList(),
                  ),
                ),

                // ── Yorumlar
                if (expert.reviews.isNotEmpty)
                  _buildSection(
                    title: 'Değerlendirmeler (${expert.reviewCount})',
                    isDark: isDark,
                    child: Column(
                      children:
                          expert.reviews.map((review) {
                            return _ReviewItem(review: review, isDark: isDark);
                          }).toList(),
                    ),
                  ),
              ],
            ),
          ),

          // ── Sabit CTA Butonu
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCTA(expert, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    ExpertProfile expert,
    dynamic catInfo,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            catInfo.color.withValues(alpha: 0.1),
            catInfo.color.withValues(alpha: 0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: catInfo.color.withValues(alpha: 0.2),
                child: Text(
                  expert.name.split(' ').map((w) => w[0]).take(2).join(),
                  style: TextStyle(
                    color: catInfo.color,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ),
              if (expert.isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppTheme.surfaceDark : Colors.white,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            expert.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            expert.title,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 14),
          // İstatistikler
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniStat(
                icon: Icons.star_rounded,
                value: expert.rating.toStringAsFixed(1),
                label: 'Puan',
                color: Colors.amber,
              ),
              const SizedBox(width: 24),
              _MiniStat(
                icon: Icons.reviews_rounded,
                value: '${expert.reviewCount}',
                label: 'Yorum',
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 24),
              _MiniStat(
                icon: Icons.work_rounded,
                value: '${expert.experienceYears} yıl',
                label: 'Deneyim',
                color: AppTheme.infoColor,
              ),
              const SizedBox(width: 24),
              _MiniStat(
                icon: Icons.check_circle,
                value: '${expert.completedConsultations}',
                label: 'Danışma',
                color: AppTheme.successColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Online durumu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color:
                  expert.isOnline
                      ? AppTheme.successColor.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        expert.isOnline ? AppTheme.successColor : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  expert.isOnline ? 'Çevrimiçi' : 'Çevrimdışı',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        expert.isOnline ? AppTheme.successColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isDark,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildCTA(ExpertProfile expert, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedPackageId != null
                        ? expert.packages
                            .firstWhere((p) => p.id == _selectedPackageId)
                            .name
                        : 'Paket seçin',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _selectedPackageId != null
                        ? expert.packages
                            .firstWhere((p) => p.id == _selectedPackageId)
                            .priceLabel
                        : expert.priceLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final pkgId =
                    _selectedPackageId ??
                    (expert.packages.isNotEmpty
                        ? expert.packages.first.id
                        : null);
                if (pkgId == null) return;
                context.push('/expert-request/${expert.id}/$pkgId');
              },
              icon: const Icon(Icons.chat_rounded, size: 18),
              label: const Text('Hemen Danış'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final dynamic review;
  final bool isDark;

  const _ReviewItem({required this.review, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: Text(
                      review.reviewerName[0],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    review.reviewerName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                  const SizedBox(width: 3),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            review.formattedDate,
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
