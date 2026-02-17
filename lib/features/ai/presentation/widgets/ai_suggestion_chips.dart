import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';

/// Quick suggestion chips shown on the welcome screen.
class AiSuggestionChips extends ConsumerWidget {
  final String context;
  const AiSuggestionChips({super.key, this.context = 'general'});

  @override
  Widget build(BuildContext context2, WidgetRef ref) {
    final suggestionsAsync = ref.watch(aiSuggestionsProvider(context));
    final isDark = Theme.of(context2).brightness == Brightness.dark;

    return suggestionsAsync.when(
      data: (suggestions) => _buildChips(context2, ref, suggestions, isDark),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => _buildChips(context2, ref, _defaultSuggestions, isDark),
    );
  }

  Widget _buildChips(
    BuildContext context,
    WidgetRef ref,
    List<String> suggestions,
    bool isDark,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children:
          suggestions.map((s) {
            return InkWell(
              onTap: () => ref.read(aiChatProvider.notifier).sendMessage(s),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : AppTheme.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  border: Border.all(
                    color:
                        isDark
                            ? AppTheme.primaryLight.withValues(alpha: 0.15)
                            : AppTheme.primaryColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color:
                        isDark ? AppTheme.primaryLight : AppTheme.primaryColor,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  static const _defaultSuggestions = [
    'Bana nasıl yardımcı olabilirsin?',
    'Kamu personeli hakları',
    'Güncel mevzuat değişiklikleri',
  ];
}
