import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';

class ProfilScreen extends ConsumerStatefulWidget {
  const ProfilScreen({super.key});

  @override
  ConsumerState<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends ConsumerState<ProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ministryController = TextEditingController();
  final _titleController = TextEditingController();
  EmploymentType? _selectedType;

  @override
  void initState() {
    super.initState();
    // Initialize with current user data
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = user.name ?? '';
      _selectedType = user.employmentType;
      _ministryController.text = user.ministryCode?.toString() ?? '';
      _titleController.text = user.title ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ministryController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen çalışma şeklinizi seçiniz.')),
      );
      return;
    }

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      name: _nameController.text.trim(),
      employmentType: _selectedType,
      title: _titleController.text.trim(),
      // ministryCode: int.tryParse(_ministryController.text.trim()), // Optional
    );

    // Call update on notifier
    await ref.read(authProvider.notifier).updateUser(updatedUser);

    if (mounted) {
      // Check for errors? authState handles it.
      final state = ref.read(authProvider);
      if (state.status == AuthStatus.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error ?? 'Hata oluştu')));
      } else {
        // Success
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Bilgileri')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Size daha iyi hizmet verebilmemiz için lütfen bilgilerinizi tamamlayın.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Employment Type Selection
              Text('Çalışma Şekli', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),

              _TypeSelectionCard(
                title: 'Memur (4A/4B/4C)',
                subtitle: 'Devlet memurları ve sözleşmeli personel',
                isSelected:
                    _selectedType == EmploymentType.memur ||
                    _selectedType == EmploymentType.sozlesmeli,
                onTap:
                    () => setState(() => _selectedType = EmploymentType.memur),
                color: Colors.blue,
                icon: Icons.account_balance,
              ),
              const SizedBox(height: 10),
              _TypeSelectionCard(
                title: 'Kamu İşçisi (4D)',
                subtitle: 'Sürekli işçi kadrosunda çalışanlar',
                isSelected: _selectedType == EmploymentType.isci,
                onTap:
                    () => setState(() => _selectedType = EmploymentType.isci),
                color: Colors.orange,
                icon: Icons.engineering,
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Title (Unvan)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Unvan (Opsiyonel)',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              KamulogButton(
                text: 'Kaydet ve Devam Et',
                onPressed: isLoading ? null : _save,
                isLoading: isLoading,
                icon: Icons.check_circle_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final IconData icon;

  const _TypeSelectionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : null,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}
