import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Story widget — Instagram tarzı yatay hikaye listesi
/// Veriler web yönetim panelinden gelecek (ayrı DB tabloso)
class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _sampleStories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final story = _sampleStories[index];
          return _StoryItem(story: story, isDark: isDark);
        },
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final StoryData story;
  final bool isDark;

  const _StoryItem({required this.story, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showStoryDetail(context, story);
      },
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            // Avatar ring
            Container(
              width: 66,
              height: 66,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    story.isViewed
                        ? LinearGradient(
                          colors: [Colors.grey.shade300, Colors.grey.shade400],
                        )
                        : const LinearGradient(
                          colors: [
                            Color(0xFFE53935),
                            Color(0xFFF9A825),
                            Color(0xFF1565C0),
                          ],
                        ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppTheme.cardDark : Colors.white,
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: story.gradientColors,
                    ),
                  ),
                  child: Center(
                    child: Icon(story.icon, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: story.isViewed ? FontWeight.w400 : FontWeight.w600,
                color: story.isViewed ? Colors.grey : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showStoryDetail(BuildContext context, StoryData story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            height: MediaQuery.of(ctx).size.height * 0.85,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: story.gradientColors,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: const LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                        minHeight: 3,
                      ),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            story.icon,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          story.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Icon(
                          story.icon,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          story.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          story.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Action button
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: story.gradientColors[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Detayları Gör',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

/// Veri modeli — web panelinden gelecek
class StoryData {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final bool isViewed;

  const StoryData({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    this.isViewed = false,
  });
}

/// Örnek veriler — gerçekte API'den gelecek
const _sampleStories = [
  StoryData(
    id: '1',
    title: 'Duyurular',
    description:
        'Güncel kamu personeli haberleri ve duyurular burada yayınlanacaktır.',
    icon: Icons.campaign_rounded,
    gradientColors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
  ),
  StoryData(
    id: '2',
    title: 'Becayiş',
    description: 'Yeni becayiş ilanları ve eşleşme fırsatları. Hemen başvurun!',
    icon: Icons.swap_horiz_rounded,
    gradientColors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  ),
  StoryData(
    id: '3',
    title: 'Kariyer',
    description: 'Bu hafta açılan yeni kamu ve özel sektör iş ilanları.',
    icon: Icons.work_rounded,
    gradientColors: [Color(0xFFE65100), Color(0xFFBF360C)],
  ),
  StoryData(
    id: '4',
    title: 'Hukuk',
    description:
        'Çalışma hukuku, işçi hakları ve güncel mevzuat değişiklikleri.',
    icon: Icons.gavel_rounded,
    gradientColors: [Color(0xFFC62828), Color(0xFF8E0000)],
  ),
  StoryData(
    id: '5',
    title: 'AI Güncel',
    description:
        'Yapay zeka ile CV analizi ve kariyer önerileri hakkında son gelişmeler.',
    icon: Icons.auto_awesome,
    gradientColors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
  ),
  StoryData(
    id: '6',
    title: 'Eğitim',
    description: 'Online eğitim fırsatları ve sertifika programları.',
    icon: Icons.school_rounded,
    gradientColors: [Color(0xFF00695C), Color(0xFF004D40)],
    isViewed: true,
  ),
  StoryData(
    id: '7',
    title: 'Maaş',
    description:
        'Kamu çalışanları maaş tabloları ve zam oranları güncellemeleri.',
    icon: Icons.calculate_rounded,
    gradientColors: [Color(0xFF37474F), Color(0xFF263238)],
    isViewed: true,
  ),
];
