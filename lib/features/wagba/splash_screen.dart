import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WagbaColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icon_fork_knife.png',
              height: 72,
              width: 72,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'Wagba',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: WagbaColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
