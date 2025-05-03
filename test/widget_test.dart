import 'dart:typed_data';
import 'package:books/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:books/presentation/widgets/searchbarWidget.dart';

void main() {
  Uint8List dummyImage = Uint8List(0); // Empty image for test purposes

  testWidgets('Searchbarwidget displays suggestions and handles submit',
      (WidgetTester tester) async {
    final List<Book> books = [
      Book(title: 'Title 1', author: 'apple', summary: 'Summary 1', image: dummyImage),
      Book(title: 'Title 2', author: 'banana', summary: 'Summary 2', image: dummyImage),
      Book(title: 'Title 3', author: 'grape', summary: 'Summary 3', image: dummyImage),
      Book(title: 'Title 4', author: 'pineapple', summary: 'Summary 4', image: dummyImage),
    ];
    String submittedValue = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Searchbarwidget(
            Books: books,
            onSubmit: (value) {
              submittedValue = value;
            },
          ),
        ),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    await tester.enterText(textFieldFinder, 'ap');
    await tester.pumpAndSettle();

    // Expect relevant suggestions
    expect(find.text('apple'), findsOneWidget);
    expect(find.text('grape'), findsOneWidget);
    expect(find.text('pineapple'), findsOneWidget);

    await tester.tap(find.text('apple'));
    await tester.pumpAndSettle();

    expect(submittedValue, '');
  });

  testWidgets('Searchbarwidget submits manual entry when not in list',
      (WidgetTester tester) async {
    final List<Book> books = [
      Book(title: 'Title 1', author: 'apple', summary: 'Summary 1', image: dummyImage),
    ];
    String submittedValue = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Searchbarwidget(
            Books: books,
            onSubmit: (value) {
              submittedValue = value;
            },
          ),
        ),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'blueberry');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(submittedValue, '');
  });
}
