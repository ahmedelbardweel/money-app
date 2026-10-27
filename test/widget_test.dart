// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_money/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AmwalApp());

    // Verify splash screen displays 'أموال'
    expect(find.text('أموال'), findsOneWidget);

    // Allow splash timer to complete and transition to LoginScreen
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify Login Screen loaded (Header and Button)
    expect(find.text('تسجيل الدخول.'), findsNWidgets(2));
  });
}
