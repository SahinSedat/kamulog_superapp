import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/utils/tc_kimlik_validator.dart';
import 'package:kamulog_superapp/core/utils/helpers.dart';
import 'package:kamulog_superapp/core/data/turkey_locations.dart';
import 'package:kamulog_superapp/core/data/public_institutions.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pinput/pinput.dart';

/// Profil düzenleme ekranı — TC doğrulama, il/ilçe dropdown, kurum arama
class ProfilEditScreen extends ConsumerStatefulWidget {
  const ProfilEditScreen({super.key});

  @override
  ConsumerState<ProfilEditScreen> createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends ConsumerState<ProfilEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tcController = TextEditingController();
  final _titleController = TextEditingController();
  final _nameController = TextEditingController();
  EmploymentType? _selectedType;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedInstitution;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    final profil = ref.read(profilProvider);
    if (user != null) {
      _selectedType = profil.employmentType ?? user.employmentType;
      _titleController.text = profil.title ?? user.title ?? '';
      _nameController.text = user.name ?? profil.name ?? '';
    }
    // Mevcut profil verilerini yükle
    _tcController.text = profil.tcKimlik ?? '';
    _selectedCity = profil.city;
    _selectedDistrict = profil.district;
    _selectedInstitution = profil.institution;
  }

  @override
  void dispose() {
    _tcController.dispose();
    _titleController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final newName = _nameController.text.trim();
    final updatedUser = currentUser.copyWith(
      name: newName,
      employmentType: _selectedType,
      title: _titleController.text.trim(),
    );

    await ref.read(authProvider.notifier).updateUser(updatedUser);

    // İsim değiştiyse profil provider'a da yansıt
    if (newName != currentUser.name) {
      ref.read(profilProvider.notifier).updateName(newName);
    }

    if (mounted) {
      // ProfilProvider'ı güncelle — profil ekranına anında yansır
      ref
          .read(profilProvider.notifier)
          .updatePersonalInfo(
            tcKimlik: _tcController.text.trim(),
            city: _selectedCity,
            district: _selectedDistrict,
            employmentType: _selectedType,
            institution: _selectedInstitution,
            title: _titleController.text.trim(),
          );

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
    final user = ref.watch(currentUserProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
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
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Ad soyad zorunludur';
                  }
                  if (v.trim().length < 3) {
                    return 'En az 3 karakter olmalıdır';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                  hintText: 'Adınız ve soyadınız',
                ),
              ),
              const SizedBox(height: 10),
              _PhoneEditField(
                phone: user?.phone ?? 'Belirtilmedi',
                onPhoneChanged: (newPhone) {
                  // Telefon değişikliği doğrulama sonrası gerçekleşir
                  ref.read(profilProvider.notifier).updatePhone(newPhone);
                  ref
                      .read(authProvider.notifier)
                      .updateUser(user!.copyWith(phone: newPhone));
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Telefon değişikliği için OTP doğrulama gereklidir.',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 24),
              // ── TC Kimlik No
              _SectionTitle(
                title: 'Kimlik Bilgileri',
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tcController,
                keyboardType: TextInputType.number,
                maxLength: 11,
                decoration: const InputDecoration(
                  labelText: 'TC Kimlik No',
                  prefixIcon: Icon(Icons.badge_outlined, size: 20),
                  counterText: '',
                  hintText: '11 haneli TC Kimlik numaranız',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return null; // Opsiyonel
                  if (v.length != 11) return '11 haneli olmalıdır';
                  if (!TcKimlikValidator.validate(v)) {
                    return 'Geçersiz TC Kimlik Numarası';
                  }
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

              // İl seçimi
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'İl',
                  prefixIcon: Icon(Icons.location_city_outlined, size: 20),
                ),
                items:
                    TurkeyLocations.cities
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedCity = v;
                    _selectedDistrict = null; // İl değişince ilçeyi sıfırla
                  });
                },
                validator: (v) => v == null ? 'İl seçiniz' : null,
              ),
              const SizedBox(height: 14),

              // İlçe seçimi
              DropdownButtonFormField<String>(
                initialValue: _selectedDistrict,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'İlçe',
                  prefixIcon: Icon(Icons.map_outlined, size: 20),
                ),
                items:
                    (_selectedCity != null
                            ? TurkeyLocations.getDistricts(_selectedCity!)
                            : <String>[])
                        .map(
                          (d) => DropdownMenuItem(
                            value: d,
                            child: Text(
                              d,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _selectedDistrict = v),
                validator:
                    (v) =>
                        v == null && _selectedCity != null
                            ? 'İlçe seçiniz'
                            : null,
              ),

              const SizedBox(height: 24),
              // ── Çalışma Bilgileri
              _SectionTitle(
                title: 'Çalışma Bilgileri',
                icon: Icons.work_outline,
              ),
              const SizedBox(height: 12),

              // Çalışma durumu
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

              // Kurum seçimi — arama destekli
              GestureDetector(
                onTap: () => _showInstitutionPicker(),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Kurum',
                      prefixIcon: const Icon(Icons.business_outlined, size: 20),
                      suffixIcon: const Icon(Icons.search_rounded, size: 20),
                      hintText: _selectedInstitution ?? 'Kurum seçiniz',
                    ),
                    controller: TextEditingController(
                      text: _selectedInstitution ?? '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Unvan',
                  prefixIcon: Icon(Icons.work_history_outlined, size: 20),
                  hintText: 'Örn: Müfettiş, Memur, Tekniker',
                ),
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
                        'TC Kimlik, kurum ve adres bilgileriniz STK üyeliği, CV oluşturma ve Becayiş ilanı için kullanılır (opsiyonel).',
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

  /// Kurum seçimi — arama destekli bottom sheet
  void _showInstitutionPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => _InstitutionPickerSheet(
            onSelected: (institution) {
              setState(() => _selectedInstitution = institution);
              Navigator.pop(ctx);
            },
          ),
    );
  }
}

// ── Kurum seçici bottom sheet
class _InstitutionPickerSheet extends StatefulWidget {
  final ValueChanged<String> onSelected;
  const _InstitutionPickerSheet({required this.onSelected});

  @override
  State<_InstitutionPickerSheet> createState() =>
      _InstitutionPickerSheetState();
}

class _InstitutionPickerSheetState extends State<_InstitutionPickerSheet> {
  final _searchController = TextEditingController();
  List<String> _filtered = PublicInstitutions.institutions;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Başlık
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Kurum Seçin',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
          // Arama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) {
                setState(() => _filtered = PublicInstitutions.search(v));
              },
              decoration: InputDecoration(
                hintText: 'Kurum ara...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Liste
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final institution = _filtered[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  leading: Icon(
                    Icons.business_outlined,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  title: Text(
                    institution,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () => widget.onSelected(institution),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Telefon düzenleme alanı (OTP doğrulama ile)
class _PhoneEditField extends ConsumerStatefulWidget {
  final String phone;
  final ValueChanged<String> onPhoneChanged;
  const _PhoneEditField({required this.phone, required this.onPhoneChanged});

  @override
  ConsumerState<_PhoneEditField> createState() => _PhoneEditFieldState();
}

class _PhoneEditFieldState extends ConsumerState<_PhoneEditField> {
  void _showPhoneChangeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => _PhoneChangeSheet(
            currentPhone: widget.phone,
            onPhoneVerified: (newPhone) {
              widget.onPhoneChanged(newPhone);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Telefon numaranız güncellendi ✓'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.phone_outlined, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Telefon',
                style: TextStyle(fontSize: 10, color: Colors.grey[400]),
              ),
              const SizedBox(height: 2),
              Text(
                widget.phone,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: _showPhoneChangeSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Değiştir',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Telefon değiştirme bottom sheet (OTP doğrulama ile)
class _PhoneChangeSheet extends ConsumerStatefulWidget {
  final String currentPhone;
  final ValueChanged<String> onPhoneVerified;

  const _PhoneChangeSheet({
    required this.currentPhone,
    required this.onPhoneVerified,
  });

  @override
  ConsumerState<_PhoneChangeSheet> createState() => _PhoneChangeSheetState();
}

class _PhoneChangeSheetState extends ConsumerState<_PhoneChangeSheet> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _phoneMask = MaskTextInputFormatter(
    mask: '### ### ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  bool _otpSent = false;
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = _phoneMask.getUnmaskedText();
    final error = Validators.validatePhone(phone);
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    final formattedPhone = Formatters.formatPhoneForApi(phone);

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    await ref.read(authProvider.notifier).sendPhoneChangeOtp(formattedPhone);

    if (mounted) {
      final authNotifier = ref.read(authProvider.notifier);
      setState(() {
        _isLoading = false;
        if (authNotifier.phoneChangeError == null) {
          _otpSent = true;
        } else {
          _errorText = authNotifier.phoneChangeError;
        }
      });
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.length < 4) {
      setState(() => _errorText = 'Doğrulama kodunu eksiksiz girin');
      return;
    }

    final phone = _phoneMask.getUnmaskedText();
    final formattedPhone = Formatters.formatPhoneForApi(phone);

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final success = await ref
        .read(authProvider.notifier)
        .verifyPhoneChangeOtp(code, formattedPhone);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        widget.onPhoneVerified(formattedPhone);
      } else {
        setState(() => _errorText = 'Doğrulama kodu hatalı');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Telefon Numarasını Değiştir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Mevcut: ${widget.currentPhone}',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
            const SizedBox(height: 20),

            if (!_otpSent) ...[
              // Yeni telefon girişi
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneMask],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Yeni Telefon Numarası',
                  hintText: '5XX XXX XX XX',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇹🇷', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(
                          '+90',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _sendOtp,
                  icon:
                      _isLoading
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.sms_outlined, color: Colors.white),
                  label: Text(
                    _isLoading ? 'Gönderiliyor...' : 'Doğrulama Kodu Gönder',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // OTP doğrulama
              const Text(
                'Doğrulama kodunu girin',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Pinput(
                controller: _otpController,
                length: 6,
                onCompleted: (_) => _verifyOtp(),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _verifyOtp,
                  icon:
                      _isLoading
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(
                            Icons.verified_outlined,
                            color: Colors.white,
                          ),
                  label: Text(
                    _isLoading ? 'Doğrulanıyor...' : 'Numarayı Doğrula',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],

            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: const TextStyle(
                  color: AppTheme.errorColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
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
