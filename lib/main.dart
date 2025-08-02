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
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(PriorityAdapter());

  await Hive.openBox<TaskModel>('tasks');

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Data Source and Repository
    final localDataSource = LocalTaskDataSource();
    final taskRepository = TaskRepositoryImpl(dataSource: localDataSource);

    // Initialize Use Cases
    final getTasks = GetTasks(taskRepository);
    final addTask = AddTask(taskRepository);
    final updateTask = UpdateTask(taskRepository);
    final deleteTask = DeleteTask(taskRepository);
    final toggleTaskStatus = ToggleTaskStatus(taskRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TaskBloc(
            getTasks: getTasks,
            addTask: addTask,
            updateTask: updateTask,
            deleteTask: deleteTask,
            toggleTaskStatus: toggleTaskStatus,
          )..add(LoadTasks()), // Optionally Load tasks at startup
        ),
        BlocProvider(create: (_) => FilterBloc()),
        BlocProvider<SortBloc>(
          create: (_) => SortBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
