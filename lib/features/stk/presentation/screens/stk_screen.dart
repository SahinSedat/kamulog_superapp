import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';

class StkScreen extends ConsumerWidget {
  const StkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.textTheme.bodyMedium?.color,
              indicatorColor: theme.colorScheme.primary,
              tabs: const [
                Tab(
                  text: 'Duyurular',
                  icon: Icon(Icons.campaign_outlined, size: 20),
                ),
                Tab(text: 'Forum', icon: Icon(Icons.forum_outlined, size: 20)),
                Tab(
                  text: 'Kuruluşlar',
                  icon: Icon(Icons.business_outlined, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _AnnouncementsTab(theme: theme),
                _ForumTab(theme: theme),
                _OrganizationsTab(theme: theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementsTab extends StatelessWidget {
  final ThemeData theme;
  const _AnnouncementsTab({required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: 10,
      itemBuilder: (context, index) {
        return KamulogCard(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kamulog STK Derneği',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${15 - index} Şubat 2026',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  KamulogBadge(
                    text: index < 3 ? 'Yeni' : 'Duyuru',
                    color:
                        index < 3 ? AppTheme.successColor : AppTheme.infoColor,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'Çalışanlar İçin Önemli Duyuru #${index + 1}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                'Bu duyuru tüm çalışanları ilgilendiren önemli gelişmeleri içermektedir. Detaylı bilgi için tıklayınız.',
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text('${42 - index * 3}', style: theme.textTheme.bodySmall),
                  const SizedBox(width: AppTheme.spacingMd),
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text('${12 - index}', style: theme.textTheme.bodySmall),
                  const Spacer(),
                  Icon(
                    Icons.share_outlined,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ForumTab extends StatelessWidget {
  final ThemeData theme;
  const _ForumTab({required this.theme});

  @override
  Widget build(BuildContext context) {
    final topics = [
      'Becayiş deneyimlerinizi paylaşın',
      'Yeni personel kanunu hakkında görüşler',
      'Emeklilik reformu tartışması',
      'İdari izin uygulamaları',
      'Disiplin cezaları hakkında bilgi',
      'Uzaktan çalışma hakları',
      'Sicil affı konusu',
      'Tayin hakkı sorunu',
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: KamulogButton(
            text: 'Yeni Konu Aç',
            onPressed: () {},
            icon: Icons.add,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return KamulogCard(
                onTap: () {},
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors
                          .primaries[index % Colors.primaries.length]
                          .withValues(alpha: 0.12),
                      child: Text(
                        'K${index + 1}',
                        style: TextStyle(
                          color:
                              Colors.primaries[index % Colors.primaries.length],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topics[index],
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.reply,
                                size: 14,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${20 - index * 2} yanıt',
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(width: AppTheme.spacingMd),
                              Icon(
                                Icons.visibility_outlined,
                                size: 14,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${150 - index * 12} görüntüleme',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrganizationsTab extends StatelessWidget {
  final ThemeData theme;
  const _OrganizationsTab({required this.theme});

  @override
  Widget build(BuildContext context) {
    final orgs = [
      {'name': 'Kamulog STK Derneği', 'members': 15420, 'type': 'Dernek'},
      {'name': 'Çalışanlar Birliği', 'members': 8750, 'type': 'Sendika'},
      {'name': 'Eğitimciler Derneği', 'members': 6200, 'type': 'Dernek'},
      {
        'name': 'Sağlık Çalışanları Platformu',
        'members': 4870,
        'type': 'Platform',
      },
      {'name': 'Adalet Çalışanları Derneği', 'members': 3540, 'type': 'Dernek'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Kuruluş ara...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            itemCount: orgs.length,
            itemBuilder: (context, index) {
              final org = orgs[index];
              return KamulogCard(
                onTap: () {},
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            org['name'] as String,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              KamulogBadge(
                                text: org['type'] as String,
                                color: AppTheme.accentColor,
                              ),
                              const SizedBox(width: AppTheme.spacingSm),
                              Icon(
                                Icons.people_outline,
                                size: 14,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${org['members']} üye',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'Katıl',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
