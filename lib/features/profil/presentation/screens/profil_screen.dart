import 'package:flutter/material.dart';

/// Profil Tamamlama / Düzenleme ekranı.
/// Kullanıcı giriş yaptıktan sonra zorunlu profil tamamlama adımı burada gerçekleşir.
/// Memur (4A/4B/4C) veya İşçi/Sözleşmeli (4D) seçimi tema değişimini tetikler.
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const Center(child: Text('Profil Modülü')),
    );
  }
}
