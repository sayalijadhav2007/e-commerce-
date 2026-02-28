import 'package:dual_role_delivery_app/application/auth/auth_controller.dart';
import 'package:dual_role_delivery_app/core/widgets/wagba_scaffold.dart';
import 'package:dual_role_delivery_app/data/wagba_providers.dart';
import 'package:dual_role_delivery_app/domain/models/wagba_models.dart';
import 'package:dual_role_delivery_app/features/wagba/cart_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/categories_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/checkout_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/home_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/meal_details_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/onboarding_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/order_done_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/order_tracking_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/orders_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/profile_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/sign_in_screen.dart';
import 'package:dual_role_delivery_app/features/wagba/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final isAuthed = authState.isAuthenticated;
      final location = state.uri.path;
      final isAuthRoute = location == '/sign-in';
      final isPublic = location == '/splash' || location == '/onboarding';

      if (isLoading) return null;
      if (!isAuthed && !isAuthRoute && !isPublic) return '/sign-in';
      if (isAuthed && (isAuthRoute || isPublic)) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            _fadeSlidePage(state, const SplashScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _fadeSlidePage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: '/sign-in',
        pageBuilder: (context, state) =>
            _fadeSlidePage(state, const SignInScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return WagbaScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) => const CategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/meal/:id',
        pageBuilder: (context, state) {
          final extraMeal = state.extra as WagbaMeal?;
          final mealId = state.pathParameters['id'];
          final repo = ref.read(wagbaRepositoryProvider);
          final mealsFuture = repo.loadMeals();
          return _fadeSlidePage(
            state,
            FutureBuilder(
              future: mealsFuture,
              builder: (context, snapshot) {
                final data = snapshot.data ?? [];
                if (extraMeal == null && data.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final resolved = extraMeal ??
                    data.firstWhere(
                      (item) => item.id == mealId,
                      orElse: () => data.isNotEmpty ? data.first : extraMeal!,
                    );
                return MealDetailsScreen(meal: resolved);
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/checkout',
        pageBuilder: (context, state) =>
            _fadeSlidePage(state, const CheckoutScreen()),
      ),
      GoRoute(
        path: '/order-done',
        pageBuilder: (context, state) {
          final orderId = state.extra as String?;
          return _fadeSlidePage(state, OrderDoneScreen(orderId: orderId));
        },
      ),
      GoRoute(
        path: '/orders',
        pageBuilder: (context, state) =>
            _fadeSlidePage(state, const OrdersScreen()),
      ),
      GoRoute(
        path: '/track/:id',
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return _fadeSlidePage(
            state,
            OrderTrackingScreen(orderId: orderId),
          );
        },
      ),
    ],
  );
});

CustomTransitionPage<void> _fadeSlidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(0.0, 0.06),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: animation.drive(tween), child: child),
      );
    },
  );
}
