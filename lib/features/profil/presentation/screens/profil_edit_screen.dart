import 'package:flutter/material.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
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
  final _emailController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _postalCodeController = TextEditingController();
  bool _obscureTC = true;
  EmploymentType? _selectedType;
  final _yearsWorkingController = TextEditingController();
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedInstitution;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    final profil = ref.read(profilProvider);
    if (user != null) {
      _selectedType = ProfilState.normalizeEmploymentType(
        profil.employmentType ?? user.employmentType,
      );
      _yearsWorkingController.text = profil.yearsWorking?.toString() ?? '';
      _titleController.text = profil.title ?? user.title ?? '';
      _nameController.text = user.name ?? profil.name ?? '';
    }
    // Mevcut profil verilerini yükle
    _tcController.text = profil.tcKimlik ?? '';
    _selectedCity = profil.city;
    _selectedDistrict = profil.district;
    _emailController.text = profil.email ?? '';
    _addressLineController.text = profil.addressLine ?? '';
    _postalCodeController.text = profil.postalCode ?? '';
    _selectedInstitution = profil.institution;

    // Dropdown değerlerini doğrula — listede yoksa null yap (crash önler)
    if (_selectedCity != null &&
        !TurkeyLocations.cities.contains(_selectedCity)) {
      _selectedCity = null;
    }
    if (_selectedDistrict != null && _selectedCity != null) {
      final districts = TurkeyLocations.getDistricts(_selectedCity!);
      if (!districts.contains(_selectedDistrict)) {
        _selectedDistrict = null;
      }
    } else if (_selectedDistrict != null && _selectedCity == null) {
      _selectedDistrict = null;
    }
  }

  @override
  void dispose() {
    _tcController.dispose();
    _titleController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _addressLineController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _showSearchableCityPicker() {
    showDialog(
      context: context,
      builder: (ctx) {
        String search = '';
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final cities = TurkeyLocations.cities;
            final filtered =
                search.isEmpty
                    ? cities
                    : cities
                        .where(
                          (c) => c.toLowerCase().contains(search.toLowerCase()),
                        )
                        .toList();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('İl Seçin'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'İl ara...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) => setDialogState(() => search = v),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final city = filtered[i];
                          final isSelected = city == _selectedCity;
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color:
                                  isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.grey,
                            ),
                            title: Text(
                              city,
                              style: TextStyle(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                color:
                                    isSelected ? AppTheme.primaryColor : null,
                              ),
                            ),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    )
                                    : null,
                            onTap: () {
                              setState(() {
                                _selectedCity = city;
                                _selectedDistrict = null;
                              });
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSearchableDistrictPicker() {
    if (_selectedCity == null) return;
    final districts = TurkeyLocations.getDistricts(_selectedCity!);
    showDialog(
      context: context,
      builder: (ctx) {
        String search = '';
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final filtered =
                search.isEmpty
                    ? districts
                    : districts
                        .where(
                          (d) => d.toLowerCase().contains(search.toLowerCase()),
                        )
                        .toList();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text('$_selectedCity - İlçe Seçin'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'İlçe ara...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) => setDialogState(() => search = v),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final district = filtered[i];
                          final isSelected = district == _selectedDistrict;
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.map_outlined,
                              size: 18,
                              color:
                                  isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.grey,
                            ),
                            title: Text(
                              district,
                              style: TextStyle(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                color:
                                    isSelected ? AppTheme.primaryColor : null,
                              ),
                            ),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    )
                                    : null,
                            onTap: () {
                              setState(() => _selectedDistrict = district);
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEmailVerificationDialog() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Önce geçerli bir e-posta adresi girin')),
      );
      return;
    }

    // Simulated verification code (ileride backend entegrasyonu yapılacak)
    final code =
        (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
    debugPrint('📧 Email verification code for $email: $code');

    final codeController = TextEditingController();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$email adresine doğrulama kodu gönderildi'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        String? errorText;
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('E-posta Doğrulama'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$email adresine gönderilen 6 haneli kodu girin.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '------',
                      errorText: errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (codeController.text.trim() == code) {
                      ref.read(profilProvider.notifier).setEmailVerified(true);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('E-posta doğrulandı ✓'),
                          backgroundColor: Color(0xFF2E7D32),
                        ),
                      );
                    } else {
                      setDialogState(
                        () => errorText = 'Hatalı kod, tekrar deneyin',
                      );
                    }
                  },
                  child: const Text('Doğrula'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Çalışma durumu değiştirme — 6 jeton
  void _showEmploymentChangeDialog(BuildContext context, WidgetRef ref) {
    final aiChat = ref.read(aiChatProvider.notifier);
    final hasCredits = aiChat.hasEnoughAiCredits(6);

    if (!hasCredits) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bu işlem için yeterli jetonunuz bulunmuyor (6 Jeton gerekli).',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Çalışma Durumu Değiştir',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            content: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Bu işlem için hesabınızdan 6 Jeton düşürülecektir.\nDevam etmek istiyor musunuz?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Vazgeç'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  ref.read(aiChatProvider.notifier).decreaseAiCredits(6);
                  await ref
                      .read(profilProvider.notifier)
                      .updatePersonalInfo(
                        employmentType: EmploymentType.isArayan,
                      );
                  setState(() {
                    _selectedType = EmploymentType.isArayan;
                  });
                  if (!mounted) return;
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Çalışma durumu kilidi açıldı. Yeni seçiminizi yapabilirsiniz. ✓',
                      ),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Onayla (6 Jeton)'),
              ),
            ],
          ),
    );
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
            addressLine: _addressLineController.text.trim(),
            postalCode: _postalCodeController.text.trim(),
            email: _emailController.text.trim(),
            employmentType: _selectedType,
            yearsWorking: int.tryParse(_yearsWorkingController.text.trim()),
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
                obscureText: _obscureTC,
                maxLength: 11,
                decoration: InputDecoration(
                  labelText: 'TC Kimlik No',
                  prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                  counterText: '',
                  hintText: '11 haneli TC Kimlik numaranız',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTC
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscureTC = !_obscureTC),
                  ),
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

              // İl seçimi — aranabilir dialog
              GestureDetector(
                onTap: () => _showSearchableCityPicker(),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'İl',
                      prefixIcon: const Icon(
                        Icons.location_city_outlined,
                        size: 20,
                      ),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      hintText: 'İl seçin',
                    ),
                    controller: TextEditingController(
                      text: _selectedCity ?? '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // İlçe seçimi — aranabilir dialog
              GestureDetector(
                onTap:
                    _selectedCity != null
                        ? () => _showSearchableDistrictPicker()
                        : null,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'İlçe',
                      prefixIcon: const Icon(Icons.map_outlined, size: 20),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      hintText:
                          _selectedCity != null
                              ? 'İlçe seçin'
                              : 'Önce il seçin',
                    ),
                    controller: TextEditingController(
                      text: _selectedDistrict ?? '',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),
              // Detaylı adres
              TextFormField(
                controller: _addressLineController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Açık Adres',
                  hintText: 'Mahalle, sokak, bina no, daire',
                  prefixIcon: Icon(Icons.home_outlined, size: 20),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 14),
              // Posta kodu
              TextFormField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                maxLength: 5,
                decoration: const InputDecoration(
                  labelText: 'Posta Kodu',
                  hintText: 'Örn: 06100',
                  prefixIcon: Icon(Icons.markunread_mailbox_outlined, size: 20),
                  counterText: '',
                ),
              ),

              const SizedBox(height: 14),
              // E-posta
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-posta Adresi',
                  hintText: 'örnek@mail.com',
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  suffixIcon: Builder(
                    builder: (context) {
                      final profil = ref.watch(profilProvider);
                      if (profil.emailVerified) {
                        return const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.verified_rounded,
                            color: Colors.green,
                            size: 20,
                          ),
                        );
                      }
                      if (profil.email != null && profil.email!.isNotEmpty) {
                        return TextButton(
                          onPressed: () => _showEmailVerificationDialog(),
                          child: const Text(
                            'Doğrula',
                            style: TextStyle(fontSize: 12),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                validator: (v) {
                  if (v != null && v.isNotEmpty && !v.contains('@')) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              // ── Çalışma Bilgileri
              _SectionTitle(
                title: 'Çalışma Bilgileri',
                icon: Icons.work_outline,
              ),
              const SizedBox(height: 12),

              // Çalışma durumu
              Builder(
                builder: (context) {
                  final profil = ref.watch(profilProvider);
                  final isLocked =
                      profil.employmentType != null &&
                      profil.employmentType != EmploymentType.isArayan;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Çalışma Bilgileri',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (isLocked) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.lock_rounded,
                              size: 14,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kilitli',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (isLocked)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 8),
                          child: GestureDetector(
                            onTap:
                                () => _showEmploymentChangeDialog(context, ref),
                            child: Text(
                              'Değiştirmek için dokunun (6 Jeton)',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _TypeChip(
                            label: '657 Memur / Sözleşmeli',
                            isSelected:
                                _selectedType == EmploymentType.kamuMemur,
                            color: const Color(0xFF1565C0),
                            onTap:
                                isLocked
                                    ? null
                                    : () => setState(
                                      () =>
                                          _selectedType =
                                              EmploymentType.kamuMemur,
                                    ),
                          ),
                          _TypeChip(
                            label: '4D Kamu İşçisi',
                            isSelected:
                                _selectedType == EmploymentType.kamuIsci,
                            color: const Color(0xFFE65100),
                            onTap:
                                isLocked
                                    ? null
                                    : () => setState(
                                      () =>
                                          _selectedType =
                                              EmploymentType.kamuIsci,
                                    ),
                          ),
                          _TypeChip(
                            label: 'Özel Sektör',
                            isSelected:
                                _selectedType == EmploymentType.ozelSektor,
                            color: const Color(0xFF00897B),
                            onTap:
                                isLocked
                                    ? null
                                    : () => setState(
                                      () =>
                                          _selectedType =
                                              EmploymentType.ozelSektor,
                                    ),
                          ),
                          _TypeChip(
                            label: 'İş Arıyorum',
                            isSelected:
                                _selectedType == EmploymentType.isArayan,
                            color: const Color(0xFF757575),
                            onTap:
                                isLocked
                                    ? null
                                    : () => setState(
                                      () =>
                                          _selectedType =
                                              EmploymentType.isArayan,
                                    ),
                          ),
                        ],
                      ),

                      // Kaç yıldır çalışıyorsun
                      if (_selectedType != null &&
                          _selectedType != EmploymentType.isArayan) ...[
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _yearsWorkingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Kaç yıldır çalışıyorsunuz?',
                            hintText: 'Örn: 5',
                            prefixIcon: const Icon(
                              Icons.timer_outlined,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
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
                        'Kurum ve adres bilgileriniz STK üyeliği, CV oluşturma ve Becayiş ilanı için kullanılır (opsiyonel).',
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
  final VoidCallback? onTap;

  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled && !isSelected ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
