import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/features/auth/presentation/screens/phone_input_screen.dart';
import 'package:kamulog_superapp/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:kamulog_superapp/features/home/presentation/screens/home_screen.dart';
import 'package:kamulog_superapp/features/danismanlik/presentation/screens/danismanlik_screen.dart';
import 'package:kamulog_superapp/features/profil/presentation/screens/profil_screen.dart';
import 'package:kamulog_superapp/features/salary/presentation/screens/salary_calculator_screen.dart';

/// Bridges Riverpod state changes to GoRouter's refreshListenable
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(Ref ref) {
    _sub = ref.listen<AuthState>(authProvider, (_, __) {
      notifyListeners();
    });
  }

  late final ProviderSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = AuthChangeNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuth = authState.status == AuthStatus.authenticated;
      final isAuthRoute =
          state.matchedLocation == '/login' || state.matchedLocation == '/otp';
      final isLoading =
          authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading;

      // Still checking auth state
      if (isLoading) return null;

      // Not authenticated — redirect to login (except auth routes)
      if (!isAuth && !isAuthRoute) return '/login';

      // Already authenticated — redirect away from auth pages
      if (isAuth && isAuthRoute) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const PhoneInputScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/consultation',
        name: 'consultation',
        builder: (context, state) => const DanismanlikScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilScreen(),
      ),
      GoRoute(
        path: '/salary-calculator',
        name: 'salary-calculator',
        builder: (context, state) => const SalaryCalculatorScreen(),
      ),
    ],
  );
});
