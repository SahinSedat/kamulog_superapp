import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ana ekran üzerindeki tab indeksini kontrol eden provider
final homeNavigationProvider =
    StateNotifierProvider<HomeNavigationNotifier, int>((ref) {
      return HomeNavigationNotifier();
    });

class HomeNavigationNotifier extends StateNotifier<int> {
  HomeNavigationNotifier() : super(2); // Varsayılan Dashboard (indeks 2)

  void setIndex(int index) {
    state = index;
  }
}
