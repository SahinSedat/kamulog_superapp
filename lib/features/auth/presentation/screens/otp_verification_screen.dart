import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/constants/api_endpoints.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/utils/helpers.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();
  Timer? _timer;
  static const int _totalSeconds = 90;
  int _countdown = _totalSeconds;
  bool _canResend = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startCountdown() {
    _countdown = _totalSeconds;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String get _formattedCountdown {
    final minutes = (_countdown ~/ 60).toString().padLeft(2, '0');
    final seconds = (_countdown % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _verify() {
    final code = _otpController.text.trim();
    if (code.length != AppConstants.otpLength) return;
    ref.read(authProvider.notifier).verifyOtp(code);
  }

  void _resend() {
    final phone = ref.read(authProvider).phone;
    if (phone != null) {
      ref.read(authProvider.notifier).sendOtp(phone);
      _otpController.clear();
      _startCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        if (next.user?.employmentType == null) {
          context.go('/profile');
        } else {
          context.go('/');
        }
      } else if (next.status == AuthStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    final defaultPinTheme = PinTheme(
      width: 52,
      height: 58,
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: theme.colorScheme.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          child: Column(
            children: [
              const SizedBox(height: AppTheme.spacingLg),

              // Circular Timer
              ScaleTransition(
                scale:
                    _canResend
                        ? const AlwaysStoppedAnimation(1.0)
                        : _pulseAnimation,
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background circle
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 4,
                          color:
                              isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.grey.shade100,
                        ),
                      ),
                      // Animated progress
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 1.0,
                            end: _countdown / _totalSeconds,
                          ),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOut,
                          builder: (context, value, _) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 4,
                              strokeCap: StrokeCap.round,
                              color:
                                  _countdown > 20
                                      ? AppTheme.primaryColor
                                      : _countdown > 10
                                      ? AppTheme.warningColor
                                      : AppTheme.errorColor,
                            );
                          },
                        ),
                      ),
                      // Timer text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _canResend ? Icons.timer_off : Icons.timer_outlined,
                            size: 22,
                            color:
                                _canResend
                                    ? AppTheme.errorColor
                                    : theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formattedCountdown,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              color:
                                  _canResend
                                      ? AppTheme.errorColor
                                      : theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Title
              Text(
                'Doğrulama Kodu',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingSm),

              // Success banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: AppTheme.successColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppTheme.successColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        authState.phone != null
                            ? '${Formatters.maskPhone(authState.phone!)} numaranıza kod gönderildi'
                            : 'Doğrulama kodu gönderildi',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.successColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // OTP Input
              Pinput(
                controller: _otpController,
                length: AppConstants.otpLength,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration?.copyWith(
                    border: Border.all(
                      color: AppTheme.successColor.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                ),
                onCompleted: (_) => _verify(),
                autofocus: true,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                animationDuration: const Duration(milliseconds: 200),
                animationCurve: Curves.easeOut,
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Verify button
              KamulogButton(
                text: 'Doğrula',
                onPressed: _verify,
                isLoading: authState.status == AuthStatus.loading,
                icon: Icons.verified_outlined,
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Resend
              AnimatedOpacity(
                opacity: _canResend ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: TextButton.icon(
                  onPressed: _canResend ? _resend : null,
                  icon: Icon(
                    _canResend ? Icons.refresh : Icons.hourglass_top,
                    size: 18,
                  ),
                  label: Text(
                    _canResend
                        ? 'Kodu Tekrar Gönder'
                        : 'Tekrar gönder ($_formattedCountdown)',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXxl),
            ],
          ),
        ),
      ),
    );
  }
}
