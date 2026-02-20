import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/providers/core_providers.dart';
import 'package:kamulog_superapp/features/e_ticaret/data/repositories/product_repository_impl.dart';
import 'package:kamulog_superapp/features/e_ticaret/domain/entities/product.dart';
import 'package:kamulog_superapp/features/e_ticaret/domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(database: ref.watch(appDatabaseProvider));
});

class ETicaretState {
  final bool isLoading;
  final List<Product> products;
  final String? error;
  final String? selectedCategory;

  const ETicaretState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.selectedCategory,
  });

  ETicaretState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
    String? selectedCategory,
  }) {
    return ETicaretState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ETicaretNotifier extends StateNotifier<ETicaretState> {
  final ProductRepository _repository;
  ETicaretNotifier(this._repository) : super(const ETicaretState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getProducts();
    result.fold(
      (f) => state = state.copyWith(isLoading: false, error: f.message),
      (list) => state = state.copyWith(isLoading: false, products: list),
    );
  }

  void filterByCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    loadProducts();
  }
}

final eTicaretProvider = StateNotifierProvider<ETicaretNotifier, ETicaretState>(
  (ref) {
    return ETicaretNotifier(ref.watch(productRepositoryProvider));
  },
);
