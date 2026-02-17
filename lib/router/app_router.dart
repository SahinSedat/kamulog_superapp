import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/features/auth/presentation/screens/phone_input_screen.dart';
import 'package:kamulog_superapp/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:kamulog_superapp/features/home/presentation/screens/home_screen.dart';
import 'package:kamulog_superapp/features/danismanlik/presentation/screens/danismanlik_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isAuthRoute =
          state.matchedLocation == '/login' || state.matchedLocation == '/otp';
      final isLoading =
          authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading;

      // Still checking auth state
      if (isLoading) return null;

      // Not authenticated — redirect to login
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
    ],
  );
});
