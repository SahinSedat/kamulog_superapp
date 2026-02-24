import 'dart:ui';
import 'package:flutter/material.dart';

/// Premium animasyonlu toast mesajı — backdrop blur + spring + progress bar
class AppToast {
  static OverlayEntry? _currentEntry;

  static void _showInternal(
    BuildContext context, {
    required String message,
    required _ToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder:
          (context) => _PremiumToast(
            message: message,
            type: type,
            duration: duration,
            onDismiss: () {
              entry.remove();
              if (_currentEntry == entry) _currentEntry = null;
            },
          ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  /// ✅ Başarı
  static void success(BuildContext context, String message) {
    _showInternal(context, message: message, type: _ToastType.success);
  }

  /// ⚠️ Uyarı
  static void warning(BuildContext context, String message) {
    _showInternal(context, message: message, type: _ToastType.warning);
  }

  /// ❌ Hata
  static void error(BuildContext context, String message) {
    _showInternal(context, message: message, type: _ToastType.error);
  }

  /// ℹ️ Bilgi
  static void info(BuildContext context, String message) {
    _showInternal(context, message: message, type: _ToastType.info);
  }
}

enum _ToastType { success, warning, error, info }

extension _ToastTypeExt on _ToastType {
  IconData get icon {
    switch (this) {
      case _ToastType.success:
        return Icons.check_circle_rounded;
      case _ToastType.warning:
        return Icons.warning_amber_rounded;
      case _ToastType.error:
        return Icons.error_outline_rounded;
      case _ToastType.info:
        return Icons.info_outline_rounded;
    }
  }

  List<Color> get gradient {
    switch (this) {
      case _ToastType.success:
        return [const Color(0xFF1B5E20), const Color(0xFF2E7D32)];
      case _ToastType.warning:
        return [const Color(0xFFE65100), const Color(0xFFF57C00)];
      case _ToastType.error:
        return [const Color(0xFFB71C1C), const Color(0xFFD32F2F)];
      case _ToastType.info:
        return [const Color(0xFF0D47A1), const Color(0xFF1565C0)];
    }
  }

  Color get progressColor {
    switch (this) {
      case _ToastType.success:
        return const Color(0xFF81C784);
      case _ToastType.warning:
        return const Color(0xFFFFCC80);
      case _ToastType.error:
        return const Color(0xFFEF9A9A);
      case _ToastType.info:
        return const Color(0xFF90CAF9);
    }
  }
}

class _PremiumToast extends StatefulWidget {
  final String message;
  final _ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _PremiumToast({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_PremiumToast> createState() => _PremiumToastState();
}

class _PremiumToastState extends State<_PremiumToast>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _blurAnim;

  @override
  void initState() {
    super.initState();

    // Giriş animasyonu — spring efektli
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.elasticOut),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _blurAnim = Tween<double>(
      begin: 0.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    // Progress bar animasyonu
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _entryController.forward();
    _progressController.forward();

    // Süre bitince kapat
    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _entryController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_entryController, _progressController]),
      builder: (context, child) {
        return Positioned.fill(
          child: GestureDetector(
            onTap: _dismiss,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                // Backdrop blur
                if (_blurAnim.value > 0)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _blurAnim.value * 0.5,
                        sigmaY: _blurAnim.value * 0.5,
                      ),
                      child: Container(
                        color: Colors.black.withValues(
                          alpha: _fadeAnim.value * 0.15,
                        ),
                      ),
                    ),
                  ),

                // Toast card
                Center(
                  child: SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.type.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: widget.type.gradient[0].withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: 30,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: widget.type.gradient[1].withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 60,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  20,
                                  24,
                                  16,
                                ),
                                child: Row(
                                  children: [
                                    // Emoji container
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          widget.type.icon,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Flexible(
                                      child: Text(
                                        widget.message,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4,
                                          letterSpacing: -0.2,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Progress bar
                              SizedBox(
                                height: 3,
                                child: LinearProgressIndicator(
                                  value: 1.0 - _progressController.value,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.1,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.type.progressColor,
                                  ),
                                  minHeight: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
