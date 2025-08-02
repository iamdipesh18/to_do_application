import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_application/app.dart';

void main() {
  testWidgets('Delete task workflow', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Add a task first
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('taskTitleField')), 'Task to Delete');
    await tester.enterText(
        find.byKey(const Key('taskDescriptionField')), 'Desc');
    await tester.tap(find.byKey(const Key('saveTaskButton')));
    await tester.pumpAndSettle();

    // Verify task is added
    expect(find.text('Task to Delete'), findsOneWidget);

    // Tap the delete button/icon on the task tile
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Verify task is removed
    expect(find.text('Task to Delete'), findsNothing);
  });
}
