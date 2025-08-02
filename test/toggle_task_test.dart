import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_application/app.dart';

void main() {
  testWidgets('Toggle task completion', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Add a task first (reuse the steps from add_task_test)
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('taskTitleField')), 'Task to Toggle');
    await tester.enterText(
        find.byKey(const Key('taskDescriptionField')), 'Desc');
    await tester.tap(find.byKey(const Key('saveTaskButton')));
    await tester.pumpAndSettle();

    // Tap the checkbox or toggle button to mark as completed
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    // Verify that the task is shown as completed (e.g., via strikethrough or checked box)
    Checkbox checkbox = tester.widget(find.byType(Checkbox).first);
    expect(checkbox.value, isTrue);
  });
}
