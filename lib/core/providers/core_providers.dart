import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/network/api_client.dart';
import 'package:kamulog_superapp/core/network/connectivity_service.dart';
import 'package:kamulog_superapp/core/storage/secure_storage_service.dart';
import 'package:kamulog_superapp/core/database/app_database.dart';

// ── Core Service Providers ──

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(storage: storage);
});

final connectivityProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final isOnlineProvider = StreamProvider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.onConnectivityChanged;
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
