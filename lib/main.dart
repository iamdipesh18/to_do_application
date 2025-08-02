import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/task_model.dart';
import 'core/enums/priority.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(PriorityAdapter());

  await Hive.openBox<TaskModel>('tasks');

  runApp(const App());
}
