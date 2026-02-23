import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kamulog_superapp/app.dart';
import 'package:kamulog_superapp/core/config/env_config.dart';
import 'package:kamulog_superapp/core/storage/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // System UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize environment
  await EnvConfig.init(env: Environment.staging);

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await LocalStorageService.init();

  // Initialize Firebase (uncomment after configuring)
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const ProviderScope(child: KamulogApp()));
}
