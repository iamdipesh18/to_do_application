import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_bloc.dart';
import 'package:to_do_application/logic/cubits/theme_cubit.dart';
import 'package:to_do_application/presentation/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskBloc() /* pass use cases if needed */),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'TODO App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.indigo,
              floatingActionButtonTheme:
                  const FloatingActionButtonThemeData(backgroundColor: Colors.indigo),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
