import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_application/data/models/task_model.dart';
import 'package:to_do_application/data/repositories/task_repository_impl.dart';
import 'package:to_do_application/data/sources/local_task_data_source.dart';
import 'package:to_do_application/domain/usecases/add_task.dart';
import 'package:to_do_application/domain/usecases/delete_task.dart';
import 'package:to_do_application/domain/usecases/get_tasks.dart';
import 'package:to_do_application/domain/usecases/toggle_task_status.dart';
import 'package:to_do_application/domain/usecases/update_task.dart';
import 'package:to_do_application/logic/blocs/filter_bloc/filter_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/sort_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_event.dart';
import 'package:to_do_application/presentation/screens/home_screen.dart';
import 'core/enums/priority.dart';

void main() async {
  // Ensures Flutter binding initialized before using async native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter to store local data
  await Hive.initFlutter();

  // Register Hive adapters for custom types stored in Hive
  Hive.registerAdapter(TaskModelAdapter()); // For TaskModel objects
  Hive.registerAdapter(PriorityAdapter()); // For Priority enum

  // Open a Hive box named 'tasks' for storing TaskModel objects
  await Hive.openBox<TaskModel>('tasks');

  // Run the main app widget
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize data source that interacts with Hive
    final localDataSource = LocalTaskDataSource();

    // Repository abstracts data source and provides interface to use cases
    final taskRepository = TaskRepositoryImpl(dataSource: localDataSource);

    // Instantiate all use cases with the repository
    final getTasks = GetTasks(taskRepository);
    final addTask = AddTask(taskRepository);
    final updateTask = UpdateTask(taskRepository);
    final deleteTask = DeleteTask(taskRepository);
    final toggleTaskStatus = ToggleTaskStatus(taskRepository);

    return MultiBlocProvider(
      providers: [
        // Provide TaskBloc with all required use cases injected
        BlocProvider(
          create: (_) => TaskBloc(
            getTasks: getTasks,
            addTask: addTask,
            updateTask: updateTask,
            deleteTask: deleteTask,
            toggleTaskStatus: toggleTaskStatus,
          )
            // Dispatch LoadTasks event on creation to fetch tasks immediately
            ..add(LoadTasks()),
        ),
        // Provide FilterBloc to manage task filtering state
        BlocProvider(create: (_) => FilterBloc()),
        // Provide SortBloc to manage sorting order state
        BlocProvider<SortBloc>(
          create: (_) => SortBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Remove debug banner
        title: 'Todo App', // App title
        theme: ThemeData(
          primarySwatch: Colors.blue, // Default Material blue theme
        ),
        // Main screen widget of the app
        home: const HomeScreen(),
      ),
    );
  }
}
