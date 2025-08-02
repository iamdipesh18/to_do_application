import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_application/app.dart';

void main() {
  testWidgets('App launches and shows Add button', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Verify that FloatingActionButton is present
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify AppBar title is present
    expect(find.text('Todo App'), findsOneWidget);
  });
}
