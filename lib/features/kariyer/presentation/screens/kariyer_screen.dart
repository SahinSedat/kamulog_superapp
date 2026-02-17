import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';

class KariyerScreen extends ConsumerStatefulWidget {
  const KariyerScreen({super.key});

  @override
  ConsumerState<KariyerScreen> createState() => _KariyerScreenState();
}

class _KariyerScreenState extends ConsumerState<KariyerScreen> {
  String _selectedFilter = 'Tümü';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search & Filter
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'İlan ara...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final filter in [
                      'Tümü',
                      'Kamu',
                      'Özel',
                      'Yeni',
                      'Favori',
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (s) =>
                              setState(() => _selectedFilter = filter),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Job listings
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _JobCard(index: index, theme: theme);
            },
          ),
        ),

        // Bottom actions
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Expanded(
                child: KamulogButton(
                  text: 'CV\'lerim',
                  onPressed: () {},
                  isOutlined: true,
                  icon: Icons.description_outlined,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: KamulogButton(
                  text: 'Başvurularım',
                  onPressed: () {},
                  isOutlined: true,
                  icon: Icons.assignment_outlined,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _JobCard extends StatelessWidget {
  final int index;
  final ThemeData theme;

  const _JobCard({required this.index, required this.theme});

  @override
  Widget build(BuildContext context) {
    final jobs = [
      {
        'title': 'Bilgi Teknolojileri Uzmanı',
        'org': 'TÜBİTAK',
        'city': 'Ankara',
        'type': 'Kamu',
      },
      {
        'title': 'Mali İşler Müdürü',
        'org': 'Maliye Bakanlığı',
        'city': 'Ankara',
        'type': 'Kamu',
      },
      {
        'title': 'İnsan Kaynakları Uzmanı',
        'org': 'SGK',
        'city': 'İstanbul',
        'type': 'Kamu',
      },
      {
        'title': 'Yazılım Mühendisi',
        'org': 'HAVELSAN',
        'city': 'Ankara',
        'type': 'Kamu',
      },
      {
        'title': 'Hukuk Müşaviri',
        'org': 'Adalet Bakanlığı',
        'city': 'Ankara',
        'type': 'Kamu',
      },
      {
        'title': 'Proje Yöneticisi',
        'org': 'Savunma Sanayii',
        'city': 'Ankara',
        'type': 'Kamu',
      },
      {
        'title': 'Veri Tabanı Yöneticisi',
        'org': 'PTT',
        'city': 'İstanbul',
        'type': 'Kamu',
      },
      {
        'title': 'Sistem Yöneticisi',
        'org': 'BDDK',
        'city': 'İstanbul',
        'type': 'Kamu',
      },
      {
        'title': 'İç Denetçi',
        'org': 'Sayıştay',
        'city': 'Ankara',
        'type': 'Kamu',
      },
      {
        'title': 'Müfettiş Yardımcısı',
        'org': 'TCMB',
        'city': 'Ankara',
        'type': 'Kamu',
      },
    ];

    final job = jobs[index % jobs.length];
    final isNew = index < 3;

    return KamulogCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(
                  Icons.business,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title']!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(job['org']!, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              if (isNew)
                const KamulogBadge(text: 'Yeni', color: AppTheme.successColor),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(job['city']!, style: theme.textTheme.bodySmall),
              const SizedBox(width: AppTheme.spacingMd),
              Icon(
                Icons.work_outline,
                size: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(job['type']!, style: theme.textTheme.bodySmall),
              const SizedBox(width: AppTheme.spacingMd),
              Icon(
                Icons.access_time,
                size: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text('${index + 1} gün önce', style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.analytics_outlined, size: 16),
                label: const Text('Analiz', style: TextStyle(fontSize: 12)),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  index % 3 == 0 ? Icons.favorite : Icons.favorite_outline,
                  size: 16,
                  color: index % 3 == 0 ? AppTheme.errorColor : null,
                ),
                label: const Text('Kaydet', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
