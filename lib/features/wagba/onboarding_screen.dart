import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:dual_role_delivery_app/core/widgets/wagba_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _pages = const [
    _OnboardingPageData(
      title: 'Choose Your Meal',
      subtitle: 'Explore a variety of meals crafted for every craving.',
      mode: _OnboardingMode.collage,
    ),
    _OnboardingPageData(
      title: 'Special Offer',
      subtitle: 'Save more with exclusive discounts and chef specials.',
      mode: _OnboardingMode.hero,
    ),
    _OnboardingPageData(
      title: 'Track Your Order',
      subtitle: 'Live updates so you always know when it arrives.',
      mode: _OnboardingMode.map,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_index == _pages.length - 1) {
      context.go('/sign-in');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WagbaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _index = value),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPage(page: page);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => context.go('/sign-in'),
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: WagbaColors.textSecondary),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _index == index ? 20 : 8,
                        decoration: BoxDecoration(
                          color: _index == index
                              ? WagbaColors.primary
                              : WagbaColors.outline,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _goNext,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                    ),
                    child: Text(_index == _pages.length - 1 ? 'Start' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData page;

  const _OnboardingPage({required this.page});

  @override
  Widget build(BuildContext context) {
    final topWidget = switch (page.mode) {
      _OnboardingMode.collage => const _FoodCollage(),
      _OnboardingMode.hero => const _HeroBanner(),
      _OnboardingMode.map => const _MapPanel(),
    };

    return Container(
      decoration: page.mode == _OnboardingMode.hero
          ? const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3D1A00), Color(0xFFFF6A00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Expanded(child: topWidget),
            const SizedBox(height: 24),
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: WagbaColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodCollage extends StatelessWidget {
  const _FoodCollage();

  static const _images = [
    'assets/images/meal_burger.jpg',
    'assets/images/meal_pizza.jpg',
    'assets/images/meal_chicken.jpg',
    'assets/images/meal_salad.jpg',
    'assets/images/meal_pasta.jpg',
    'assets/images/meal_dessert.jpg',
    'assets/images/meal_burger.jpg',
    'assets/images/meal_pizza.jpg',
    'assets/images/meal_chicken.jpg',
    'assets/images/meal_salad.jpg',
    'assets/images/meal_pasta.jpg',
    'assets/images/meal_dessert.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return WagbaImage(
          path: _images[index],
          borderRadius: BorderRadius.circular(14),
        );
      },
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x14FFFFFF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WagbaImage(
              path: 'assets/images/hero_chef.jpg',
              height: 220,
              width: 260,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            const SizedBox(height: 16),
            Text(
              'Up to 30% off today',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPanel extends StatelessWidget {
  const _MapPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: WagbaColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WagbaImage(
              path: 'assets/images/onboarding_map.png',
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 12),
            Text(
              'Live Map Tracking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              'Follow your order in real time.',
              style: TextStyle(color: WagbaColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

enum _OnboardingMode { collage, hero, map }

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final _OnboardingMode mode;

  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.mode,
  });
}
