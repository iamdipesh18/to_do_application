import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
// I will create this later
// import 'data/models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize Hive and set storage directory
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // 🔹 Register Hive adapters (I will do this once TaskModel is ready)
  // Hive.registerAdapter(TaskModelAdapter());
  // Hive.registerAdapter(TaskPriorityAdapter());

  // 🔹 Open the task box (like a database table)
  // We'll call it 'tasks' and store all TaskModel objects in it
  // await Hive.openBox<TaskModel>('tasks');

  runApp(const MyApp());
}
