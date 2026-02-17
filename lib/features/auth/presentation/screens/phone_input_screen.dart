import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/utils/helpers.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneMask = MaskTextInputFormatter(
    mask: '### ### ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  bool _isLogin = true;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneMask.getUnmaskedText();
    final formattedPhone = Formatters.formatPhoneForApi(phone);

    if (_isLogin) {
      ref.read(authProvider.notifier).sendOtp(formattedPhone);
    } else {
      ref
          .read(authProvider.notifier)
          .register(phone: formattedPhone, name: _nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.otpSent) {
        context.push('/otp');
      } else if (next.status == AuthStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppTheme.spacingXxl),

                  // Logo & Title
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  Text(
                    'Kamulog',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Kamu çalışanları platformu',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingXxl),

                  // Toggle Login/Register
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TabButton(
                            text: 'Giriş Yap',
                            isSelected: _isLogin,
                            onTap: () => setState(() => _isLogin = true),
                          ),
                        ),
                        Expanded(
                          child: _TabButton(
                            text: 'Kayıt Ol',
                            isSelected: !_isLogin,
                            onTap: () => setState(() => _isLogin = false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Name field (register only)
                  if (!_isLogin) ...[
                    KamulogTextField(
                      controller: _nameController,
                      labelText: 'Ad Soyad',
                      hintText: 'Adınızı giriniz',
                      prefixIcon: Icons.person_outline,
                      validator: (v) =>
                          Validators.validateRequired(v, 'Ad Soyad'),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                  ],

                  // Phone field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      _phoneMask,
                      FilteringTextInputFormatter.allow(RegExp(r'[\d\s]')),
                    ],
                    validator: (v) =>
                        Validators.validatePhone(_phoneMask.getUnmaskedText()),
                    decoration: InputDecoration(
                      labelText: 'Telefon Numarası',
                      hintText: '5XX XXX XX XX',
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '🇹🇷 +90',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                      helperText: 'WhatsApp doğrulaması için zorunlu',
                      helperStyle: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Submit button
                  KamulogButton(
                    text: _isLogin ? 'Doğrulama Kodu Gönder' : 'Kayıt Ol',
                    onPressed: _submit,
                    isLoading: authState.status == AuthStatus.loading,
                    icon: Icons.sms_outlined,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Info text
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: AppTheme.infoColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: AppTheme.infoColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: AppTheme.infoColor.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: AppTheme.spacingSm),
                        Expanded(
                          child: Text(
                            'Doğrulama kodu WhatsApp üzerinden gönderilecektir.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.infoColor.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXxl),

                  // Legal links
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Gizlilik Politikası',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Text('•', style: TextStyle(color: Colors.grey.shade400)),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'KVKK',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Text('•', style: TextStyle(color: Colors.grey.shade400)),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Kullanım Koşulları',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
