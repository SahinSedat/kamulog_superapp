import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';

/// Profil düzenleme ekranı — TC, adres, kurum, unvan
class ProfilEditScreen extends ConsumerStatefulWidget {
  const ProfilEditScreen({super.key});

  @override
  ConsumerState<ProfilEditScreen> createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends ConsumerState<ProfilEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tcController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _titleController = TextEditingController();
  final _institutionController = TextEditingController();
  EmploymentType? _selectedType;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = user.name ?? '';
      _selectedType = user.employmentType;
      _titleController.text = user.title ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tcController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _titleController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      name: _nameController.text.trim(),
      employmentType: _selectedType,
      title: _titleController.text.trim(),
    );

    await ref.read(authProvider.notifier).updateUser(updatedUser);

    if (mounted) {
      final state = ref.read(authProvider);
      if (state.status == AuthStatus.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error ?? 'Hata oluştu')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil güncellendi ✓'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: isLoading ? null : _save,
            child: const Text(
              'Kaydet',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Kişisel Bilgiler
              _SectionTitle(
                title: 'Kişisel Bilgiler',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                label: 'Ad Soyad',
                icon: Icons.person_outline,
                validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _tcController,
                label: 'TC Kimlik No',
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                maxLength: 11,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Zorunlu alan';
                  if (v.length != 11) return 'TC Kimlik No 11 haneli olmalıdır';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              // ── Adres Bilgileri
              _SectionTitle(
                title: 'Adres Bilgileri',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _cityController,
                label: 'İl',
                icon: Icons.location_city_outlined,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _addressController,
                label: 'Açık Adres',
                icon: Icons.home_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              // ── Çalışma Bilgileri
              _SectionTitle(
                title: 'Çalışma Bilgileri',
                icon: Icons.work_outline,
              ),
              const SizedBox(height: 12),

              // Employment Type
              Text(
                'Çalışma Durumu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _TypeChip(
                    label: 'Memur',
                    isSelected: _selectedType == EmploymentType.memur,
                    color: const Color(0xFF1565C0),
                    onTap:
                        () => setState(
                          () => _selectedType = EmploymentType.memur,
                        ),
                  ),
                  const SizedBox(width: 8),
                  _TypeChip(
                    label: 'Kamu İşçisi',
                    isSelected: _selectedType == EmploymentType.isci,
                    color: const Color(0xFFE65100),
                    onTap:
                        () =>
                            setState(() => _selectedType = EmploymentType.isci),
                  ),
                  const SizedBox(width: 8),
                  _TypeChip(
                    label: 'Sözleşmeli',
                    isSelected: _selectedType == EmploymentType.sozlesmeli,
                    color: const Color(0xFF7B1FA2),
                    onTap:
                        () => setState(
                          () => _selectedType = EmploymentType.sozlesmeli,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _buildTextField(
                controller: _institutionController,
                label: 'Kurum Adı',
                icon: Icons.business_outlined,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _titleController,
                label: 'Unvan',
                icon: Icons.work_history_outlined,
              ),

              const SizedBox(height: 32),
              // ── Kaydet Butonu
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'Bilgileri Kaydet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 16),
              // ── Bilgilendirme
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.infoColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: AppTheme.infoColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'TC Kimlik ve adres bilgileriniz STK üyeliği, CV oluşturma ve Becayiş ilanı vermek için zorunludur.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.infoColor.withValues(alpha: 0.8),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        counterText: '',
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
