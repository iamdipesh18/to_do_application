import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/models/task_model.dart';
import 'core/enums/priority.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register Hive adapters for TaskModel and Priority Enum
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());

  // Open the Hive box for tasks
  await Hive.openBox<TaskModel>('tasks');

  runApp(const MyApp());
}
