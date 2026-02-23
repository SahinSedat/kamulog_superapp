import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kamulog_superapp/features/subscription/data/subscription_service.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

final subscriptionStateProvider = StateNotifierProvider<
  SubscriptionNotifier,
  AsyncValue<List<ProductDetails>>
>((ref) {
  final service = ref.watch(subscriptionServiceProvider);
  return SubscriptionNotifier(service, ref);
});

class SubscriptionNotifier
    extends StateNotifier<AsyncValue<List<ProductDetails>>> {
  final SubscriptionService _service;
  final Ref _ref;

  SubscriptionNotifier(this._service, this._ref)
    : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final products = await _service.fetchProducts();

      // Dinleyici tanımla
      _service.onPurchaseUpdate = (purchases) {
        for (var purchase in purchases) {
          if (purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored) {
            _handleSuccessfulPurchase(purchase);
            if (purchase.pendingCompletePurchase) {
              InAppPurchase.instance.completePurchase(purchase);
            }
          } else if (purchase.status == PurchaseStatus.error) {
            // Handle error state
          }
        }
      };

      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    // Burada satın alınan id'ye göre profile jeton/sınırsız erişim tanımlaması yapıyoruz.
    // Şimdilik sınırsız erişim tanımlaması (veya belirli miktar jeton) eklenecek:
    // ref.read(profilProvider.notifier).setUnlimitedCredits() gibi bir metot eklenebilir.
    // Ya da 1000 kredi verilir.

    // Geçici Demo Jetonu Ekleme:
    await _ref.read(profilProvider.notifier).addCredits(100);
  }

  Future<void> buyPlan(ProductDetails plan) async {
    try {
      await _service.buyProduct(plan);
    } catch (e) {
      // Satın alım tetiklenemedi.
    }
  }
}
