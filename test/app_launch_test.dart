import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_application/app.dart';

void main() {
  testWidgets('App launches and shows basic UI', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Check if app title is shown in AppBar
    expect(find.text('Todo App'), findsOneWidget);

    // Check if floating action button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
