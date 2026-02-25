import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// AI Arama Çubuğu — gradient arka plan, responsive
class AiSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const AiSearchBar({super.key, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'AI Uzman Eşleştirme',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 11,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'AI',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sorununuzu kısaca anlatın...',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AI Arama Dialog — tam metin girişi
class AiSearchDialog extends StatefulWidget {
  final Function(String) onSubmit;
  final bool isDark;

  const AiSearchDialog({
    super.key,
    required this.onSubmit,
    required this.isDark,
  });

  @override
  State<AiSearchDialog> createState() => _AiSearchDialogState();
}

class _AiSearchDialogState extends State<AiSearchDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: widget.isDark ? AppTheme.surfaceDark : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFF6366F1), size: 22),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI Uzman Eşleştirme',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Sorununuzu detaylı anlatın. AI en uygun uzmanı bulacak.',
              style: TextStyle(
                fontSize: 12,
                color: widget.isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 3,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Örn: Disiplin soruşturması açıldı, ne yapmalıyım?',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor:
                    widget.isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color:
                        widget.isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color:
                        widget.isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6366F1),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    widget.onSubmit(_controller.text.trim());
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('AI ile Analiz Et'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
