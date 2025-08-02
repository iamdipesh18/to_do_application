import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/colors.dart';
import 'data/repositories/task_repository_impl.dart';
import 'data/sources/local_task_data_source.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/delete_task.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/toggle_task_status.dart';
import 'domain/usecases/update_task.dart';
import 'logic/blocs/task_bloc/task_bloc.dart';
import 'logic/blocs/task_bloc/task_event.dart';
import 'logic/blocs/filter_bloc/filter_bloc.dart';
import 'presentation/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup repository and use cases
    final localDataSource = LocalTaskDataSource();
    final taskRepository = TaskRepositoryImpl(dataSource: localDataSource);

    final getTasks = GetTasks(taskRepository);
    final addTask = AddTask(taskRepository);
    final updateTask = UpdateTask(taskRepository);
    final deleteTask = DeleteTask(taskRepository);
    final toggleTaskStatus = ToggleTaskStatus(taskRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(
            getTasks: getTasks,
            addTask: addTask,
            updateTask: updateTask,
            deleteTask: deleteTask,
            toggleTaskStatus: toggleTaskStatus,
          )..add(LoadTasks()),
        ),
        BlocProvider<FilterBloc>(
          create: (_) => FilterBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.secondary,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
