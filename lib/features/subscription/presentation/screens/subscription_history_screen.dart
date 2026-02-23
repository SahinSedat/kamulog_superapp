import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

class SubscriptionHistoryScreen extends ConsumerWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final profil = ref.watch(profilProvider);
    final isPremium = profil.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Üyelik & Abonelik'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mevcut Planınız',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _MembershipCard(
              isDark: isDark,
              profil: profil,
              isPremium: isPremium,
            ),
            const SizedBox(height: 24),
            const Text(
              'Abonelik Geçmişi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Mock Geçmiş Listesi
            if (!isPremium)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Henüz bir abonelik geçmişiniz bulunmuyor.',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFD4AF37),
                    child: Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: const Text('Premium Plan'),
                  subtitle: const Text('Başarılı ödeme işlemi'),
                  trailing: const Text(
                    '₺99.99',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MembershipCard extends ConsumerWidget {
  final bool isDark;
  final ProfilState profil;
  final bool isPremium;

  const _MembershipCard({
    required this.isDark,
    required this.profil,
    required this.isPremium,
  });

  String _premiumSubText() {
    if (profil.subscriptionEndDate != null) {
      final d = profil.subscriptionEndDate!;
      return 'Tüm limitler kaldırıldı (Bitiş: ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year})';
    }
    return 'Tüm limitler kaldırıldı (Sınırsız)';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
            isPremium
                ? const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFB58E2E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isPremium)
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          else
            BoxShadow(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPremium
                      ? Icons.workspace_premium_rounded
                      : Icons.star_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPremium ? 'Premium Üye' : 'Temel Plan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isPremium
                          ? _premiumSubText()
                          : 'Premium\'a yükselterek tüm özelliklere erişin',
                      style: TextStyle(
                        color: isPremium ? Colors.white : Colors.white70,
                        fontSize: 11,
                        fontWeight:
                            isPremium ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (!isPremium)
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push('/upgrade'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Planı Yükselt',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text('Aboneliği İptal Et'),
                              content: const Text(
                                'Abonelik iptali için Apple/Google mağaza ayarlarına yönlendirileceksiniz. '
                                'Onaylıyor musunuz?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text(
                                    'Vazgeç',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    // Simüle iptal
                                    ref
                                        .read(profilProvider.notifier)
                                        .cancelPremium();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Abonelik mağaza üzerinden iptal edildi.',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'İptal Et',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white30),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Aboneliği İptal Et',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
