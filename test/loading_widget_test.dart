import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Update the import
import 'package:books/presentation/widgets/loadingWidget.dart'; // Update the import

void main() {
  testWidgets('LoadingWidget displays loading animation and text', (
    WidgetTester tester,
  ) async {
    // Pump the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingWidget(),
        ),
      ),
    );

    // Ensure the "Loading Your books" text is displayed
    final textFinder = find.text('Loading Your books');
    expect(textFinder, findsOneWidget);

  });
}
