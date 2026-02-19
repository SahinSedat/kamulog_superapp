import 'package:flutter/material.dart';

/// Mini E-Ticaret ana ekranı.
/// Kurumsal ürünlerin listelendiği, sepet ve sipariş takibi içeren modül.
class ETicaretScreen extends StatelessWidget {
  const ETicaretScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mağaza')),
      body: const Center(child: Text('E-Ticaret Modülü')),
    );
  }
}
