import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';

class BecayisScreen extends ConsumerStatefulWidget {
  const BecayisScreen({super.key});

  @override
  ConsumerState<BecayisScreen> createState() => _BecayisScreenState();
}

class _BecayisScreenState extends ConsumerState<BecayisScreen> {
  String? _selectedCity;
  String? _selectedInstitution;

  final _cities = [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    'Antalya',
    'Adana',
    'Konya',
    'Gaziantep',
    'Mersin',
    'Kayseri',
    'Eskişehir',
    'Trabzon',
    'Samsun',
    'Diyarbakır',
    'Erzurum',
  ];

  final _institutions = [
    'Milli Eğitim Bakanlığı',
    'Sağlık Bakanlığı',
    'Adalet Bakanlığı',
    'İçişleri Bakanlığı',
    'Maliye Bakanlığı',
    'Tarım ve Orman Bakanlığı',
    'Çevre Bakanlığı',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Filter bar
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCity,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Şehir',
                        prefixIcon: Icon(Icons.location_city, size: 20),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Tümü'),
                        ),
                        ..._cities.map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (v) => setState(() => _selectedCity = v),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedInstitution,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Kurum',
                        prefixIcon: Icon(Icons.business, size: 20),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Tümü'),
                        ),
                        ..._institutions.map(
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text(
                              i,
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged:
                          (v) => setState(() => _selectedInstitution = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Row(
                children: [
                  Expanded(
                    child: KamulogButton(
                      text: 'Talep Oluştur',
                      onPressed: () => _showCreateSheet(context),
                      icon: Icons.add,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: KamulogButton(
                      text: 'Eşleşmeler',
                      onPressed: () {},
                      isOutlined: true,
                      icon: Icons.handshake_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Listings
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            itemCount: 8,
            itemBuilder: (context, index) {
              return _BecayisCard(
                index: index,
                theme: theme,
                cities: _cities,
                institutions: _institutions,
              );
            },
          ),
        ),
      ],
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLg),
        ),
      ),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: AppTheme.spacingLg,
              right: AppTheme.spacingLg,
              top: AppTheme.spacingLg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Text(
                  'Becayiş Talebi Oluştur',
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.spacingLg),
                const KamulogTextField(
                  labelText: 'Mevcut Şehir',
                  prefixIcon: Icons.location_on,
                  hintText: 'Bulunduğunuz şehir',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const KamulogTextField(
                  labelText: 'Hedef Şehir',
                  prefixIcon: Icons.flag,
                  hintText: 'Gitmek istediğiniz şehir',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const KamulogTextField(
                  labelText: 'Kurum',
                  prefixIcon: Icons.business,
                  hintText: 'Çalıştığınız kurum',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const KamulogTextField(
                  labelText: 'Pozisyon / Unvan',
                  prefixIcon: Icons.badge,
                  hintText: 'Pozisyonunuz',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                const KamulogTextField(
                  labelText: 'Ek Bilgi',
                  prefixIcon: Icons.note,
                  hintText: 'Varsa ek bilgi...',
                  maxLines: 3,
                ),
                const SizedBox(height: AppTheme.spacingLg),
                KamulogButton(
                  text: 'Talebi Gönder',
                  onPressed: () => Navigator.pop(ctx),
                  icon: Icons.send,
                ),
                const SizedBox(height: AppTheme.spacingLg),
              ],
            ),
          ),
    );
  }
}

class _BecayisCard extends StatelessWidget {
  final int index;
  final ThemeData theme;
  final List<String> cities;
  final List<String> institutions;

  const _BecayisCard({
    required this.index,
    required this.theme,
    required this.cities,
    required this.institutions,
  });

  @override
  Widget build(BuildContext context) {
    final fromCity = cities[index % cities.length];
    final toCity = cities[(index + 3) % cities.length];
    final inst = institutions[index % institutions.length];

    return KamulogCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
                child: Text(
                  'K${index + 1}',
                  style: const TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  inst,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              KamulogBadge(
                text: index < 2 ? 'Yeni' : 'Aktif',
                color: index < 2 ? AppTheme.successColor : AppTheme.infoColor,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          // Route display
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm + 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fromCity,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLg,
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.flag, color: AppTheme.successColor, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      toCity,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: [
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message_outlined, size: 16),
                label: const Text('Mesaj', style: TextStyle(fontSize: 12)),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite_outline, size: 16),
                label: const Text('Kaydet', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
