import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get onConnectivityChanged => _controller.stream;
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_updateStatus);
    _checkInitial();
  }

  Future<void> _checkInitial() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final connected = results.any((r) => r != ConnectivityResult.none);
    if (_isConnected != connected) {
      _isConnected = connected;
      _controller.add(connected);
      debugPrint('🔌 Connectivity: ${connected ? "Online" : "Offline"}');
    }
  }

  void dispose() {
    _controller.close();
  }
}
