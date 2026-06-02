import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_controller.dart';
import '../features/auth/presentation/access_gate_screen.dart';
import '../features/game_modes/presentation/game_mode_shell.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/store/presentation/store_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final hasAccess = authState.valueOrNull?.hasAccess == true;
      final isGate = state.matchedLocation == '/access';
      if (!hasAccess && !isGate) return '/access';
      if (hasAccess && isGate) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/access',
        builder: (context, state) => const AccessGateScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile/:uid',
        builder: (context, state) => ProfileScreen(uid: state.pathParameters['uid'] ?? ''),
      ),
      GoRoute(
        path: '/store',
        builder: (context, state) => const StoreScreen(),
      ),
      GoRoute(
        path: '/game/:mode',
        builder: (context, state) => GameModeShell(mode: state.pathParameters['mode'] ?? 'daily'),
      ),
    ],
  );
});
