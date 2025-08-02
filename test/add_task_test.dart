import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_application/app.dart';

void main() {
  testWidgets('Add task workflow', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Tap the floating action button to open task form/dialog
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Enter task title
    await tester.enterText(
        find.byKey(const Key('taskTitleField')), 'Test Task');

    // Enter task description
    await tester.enterText(
        find.byKey(const Key('taskDescriptionField')), 'Test Description');

    // Tap save button
    await tester.tap(find.byKey(const Key('saveTaskButton')));
    await tester.pumpAndSettle();

    // Verify task appears in the task list
    expect(find.text('Test Task'), findsOneWidget);
  });
}
