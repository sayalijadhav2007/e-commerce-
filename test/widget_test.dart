import 'package:dual_role_delivery_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App loads onboarding after splash', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: WagbaApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Choose Your Meal'), findsOneWidget);
  });
}
