import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/riverpod/auth_riverpod.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/explore/presentation/pages/main_navigation_layout.dart';
import '../../features/explore/presentation/pages/detail_page.dart';
import '../../features/explore/presentation/pages/story_detail_page.dart';
import '../../features/guardian/presentation/pages/recording_preview_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/comunity/presentation/pages/ommunity_selector_page.dart';
import '../../features/explore/presentation/pages/empty_home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final goRouter = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (location == '/splash' || location == '/onboarding') {
        return null;
      }

      final authState = ref.read(authProvider).asData?.value;
      final isAuthenticated = authState?.isAuthenticated ?? false;

      if (isAuthenticated &&
          (location == '/login' || location == '/register')) {
        return '/';
      }
      if (!isAuthenticated &&
          (location.startsWith('/home') || location == '/')) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const MainNavigationLayout(),
      ),
      GoRoute(
        path: '/detail',
        builder: (_, __) => const DetailPage(),
      ),
      GoRoute(
        path: '/story-detail',
        builder: (_, __) => const StoryDetailPage(),
      ),
      GoRoute(
        path: '/preview',
        builder: (_, __) => const RecordingPreviewPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/community',
        builder: (_, __) => const CommunitySelectorPage(),
      ),
      GoRoute(
        path: '/empty',
        builder: (_, __) => const EmptyHomePage(),
      ),
    ],
  );

  ref.listen<AsyncValue<AuthState>>(authProvider, (prev, next) {
    final isAuthenticated = next.asData?.value.isAuthenticated ?? false;
    final wasAuthenticated = prev?.asData?.value.isAuthenticated ?? false;

    if (isAuthenticated && !wasAuthenticated) {
      goRouter.go('/');
    } else if (!isAuthenticated && wasAuthenticated) {
      goRouter.go('/login');
    }
  });

  return goRouter;
});
