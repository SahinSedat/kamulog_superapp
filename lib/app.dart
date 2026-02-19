import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/router/app_router.dart';

class KamulogApp extends ConsumerWidget {
  const KamulogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final user = ref.watch(currentUserProvider);
    final employmentType = user?.employmentType;

    return MaterialApp.router(
      title: 'Kamulog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        brightness: Brightness.light,
        type: employmentType,
      ),
      darkTheme: AppTheme.getTheme(
        brightness: Brightness.dark,
        type: employmentType,
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
