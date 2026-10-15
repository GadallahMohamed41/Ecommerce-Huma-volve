import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/primary_button.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/custom_text_field.dart';

void main() {
  group('Core Widgets Smoke Tests', () {
    testWidgets('PrimaryButton renders label and triggers onPressed', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Checkout',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byType(PrimaryButton));
      expect(pressed, isTrue);
    });

    testWidgets('PrimaryButton shows loading indicator and disables tap when isLoading is true',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Submit',
              isLoading: true,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);

      await tester.tap(find.byType(PrimaryButton));
      expect(pressed, isFalse);
    });

    testWidgets('CustomTextField renders hint and prefix icon', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hintText: 'Enter Email',
              prefixIcon: Icons.email_outlined,
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Enter Email'), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      expect(controller.text, 'test@example.com');
    });
  });
}
