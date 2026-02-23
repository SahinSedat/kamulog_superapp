import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Available standard product IDs (should match App Store & Google Play configurations)
  final Set<String> _kIds = <String>{
    'kamulog_premium_monthly',
    'kamulog_premium_yearly',
  };

  /// On purchase complete, we handle the callback
  void Function(List<PurchaseDetails>)? onPurchaseUpdate;

  SubscriptionService() {
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        if (onPurchaseUpdate != null) {
          onPurchaseUpdate!(purchaseDetailsList);
        }
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // handle error
      },
    );
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<bool> isAvailable() async {
    return await _iap.isAvailable();
  }

  Future<List<ProductDetails>> fetchProducts() async {
    final bool available = await isAvailable();
    if (!available) {
      return [];
    }
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      _kIds,
    );
    if (response.notFoundIDs.isNotEmpty) {
      // Handle not found IDs
    }
    return response.productDetails;
  }

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    // Determine if it's a subscription or a consumable. We treat these as Non-consumables/Subscriptions
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
}

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final service = SubscriptionService();
  ref.onDispose(() => service.dispose());
  return service;
});
