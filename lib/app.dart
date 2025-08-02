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
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
