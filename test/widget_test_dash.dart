import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project/students/Dashboard/trial3.dart';
import 'package:project/students/Order/cart.dart';

void main() {
  testWidgets('verify appearance and matching of widgets', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(const MaterialApp(home: MyHomePage3()));

    // Verify that the app bar title matches the expected text
    expect(find.text('Ready? Set, Order!'), findsOneWidget);

    // Tap on the shopping cart icon
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // Verify that the CartPage widget is displayed on the screen
    expect(find.byType(CartPage), findsOneWidget);
  });
}
