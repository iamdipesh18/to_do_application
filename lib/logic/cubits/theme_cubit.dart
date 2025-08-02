import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ThemeCubit controls the light/dark mode of the app.
/// Emits `ThemeMode.light` or `ThemeMode.dark` based on current state.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light); // Default is light theme

  /// Toggles between light and dark themes
  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
