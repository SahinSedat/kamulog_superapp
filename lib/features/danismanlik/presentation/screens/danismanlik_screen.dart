import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';

class DanismanlikScreen extends ConsumerStatefulWidget {
  const DanismanlikScreen({super.key});

  @override
  ConsumerState<DanismanlikScreen> createState() => _DanismanlikScreenState();
}

class _DanismanlikScreenState extends ConsumerState<DanismanlikScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Danışmanlık')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.textTheme.bodyMedium?.color,
              indicatorColor: theme.colorScheme.primary,
              tabs: const [Tab(text: 'Taleplerim'), Tab(text: 'Yeni Talep')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _TicketListTab(theme: theme),
                  _CreateTicketTab(theme: theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketListTab extends StatelessWidget {
  final ThemeData theme;
  const _TicketListTab({required this.theme});

  @override
  Widget build(BuildContext context) {
    final tickets = [
      {
        'title': 'İdari izin hakkında bilgi',
        'status': 'Açık',
        'date': '15 Şubat 2026',
        'category': 'İdari',
      },
      {
        'title': 'Tayin başvurusu sorunu',
        'status': 'Devam Ediyor',
        'date': '14 Şubat 2026',
        'category': 'Hukuki',
      },
      {
        'title': 'Maaş hesaplama hatası',
        'status': 'Çözüldü',
        'date': '12 Şubat 2026',
        'category': 'Mali',
      },
      {
        'title': 'Sicil düzeltme talebi',
        'status': 'Çözüldü',
        'date': '10 Şubat 2026',
        'category': 'İdari',
      },
      {
        'title': 'Disiplin soruşturması desteği',
        'status': 'Açık',
        'date': '8 Şubat 2026',
        'category': 'Hukuki',
      },
    ];

    if (tickets.isEmpty) {
      return const KamulogEmptyState(
        icon: Icons.support_agent,
        title: 'Henüz talebiniz yok',
        subtitle:
            'Danışmanlık talebi oluşturmak için "Yeni Talep" sekmesini kullanın.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        final statusColor = switch (ticket['status']) {
          'Açık' => AppTheme.warningColor,
          'Devam Ediyor' => AppTheme.infoColor,
          'Çözüldü' => AppTheme.successColor,
          _ => AppTheme.textSecondaryLight,
        };

        return KamulogCard(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(
                      ticket['status'] == 'Çözüldü'
                          ? Icons.check_circle_outline
                          : Icons.pending_outlined,
                      color: statusColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket['title']!,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            KamulogBadge(
                              text: ticket['category']!,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            KamulogBadge(
                              text: ticket['status']!,
                              color: statusColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(ticket['date']!, style: theme.textTheme.bodySmall),
                  const Spacer(),
                  if (ticket['status'] != 'Çözüldü')
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_outlined, size: 16),
                      label: const Text(
                        'Mesaj',
                        style: TextStyle(fontSize: 12),
                      ),
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

class _CreateTicketTab extends StatefulWidget {
  final ThemeData theme;
  const _CreateTicketTab({required this.theme});

  @override
  State<_CreateTicketTab> createState() => _CreateTicketTabState();
}

class _CreateTicketTabState extends State<_CreateTicketTab> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.infoColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: AppTheme.infoColor.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppTheme.infoColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Text(
                    'Hukuki veya idari konularda uzman danışmanlarımızdan destek alın.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.infoColor.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Danışmanlık Kategorisi',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: const [
              DropdownMenuItem(
                value: 'hukuki',
                child: Text('Hukuki Danışmanlık'),
              ),
              DropdownMenuItem(
                value: 'idari',
                child: Text('İdari Danışmanlık'),
              ),
              DropdownMenuItem(value: 'mali', child: Text('Mali Danışmanlık')),
              DropdownMenuItem(
                value: 'kariyer',
                child: Text('Kariyer Danışmanlık'),
              ),
              DropdownMenuItem(value: 'diger', child: Text('Diğer')),
            ],
            onChanged: (v) => setState(() => _selectedCategory = v),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          const KamulogTextField(
            labelText: 'Konu',
            hintText: 'Danışmanlık talebinizin konusu',
            prefixIcon: Icons.subject,
          ),
          const SizedBox(height: AppTheme.spacingMd),

          const KamulogTextField(
            labelText: 'Açıklama',
            hintText: 'Detaylı açıklama yazın...',
            prefixIcon: Icons.description_outlined,
            maxLines: 5,
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // File upload
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Text('Dosya Yükle', style: widget.theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  'PDF, resim veya belge ekleyin',
                  style: widget.theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.spacingSm),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file, size: 18),
                  label: const Text('Dosya Seç'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),

          KamulogButton(
            text: 'Talebi Gönder',
            onPressed: () {},
            icon: Icons.send,
          ),
        ],
      ),
    );
  }
}
