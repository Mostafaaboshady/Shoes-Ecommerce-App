import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  // The initial state is now explicitly light mode
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const String _themeKey = 'themeMode';

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // If no theme has been saved, default to light mode
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.light.index;
    emit(ThemeMode.values[themeIndex]);
  }

  Future<void> toggleTheme(bool isDarkMode) async {
    final newThemeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, newThemeMode.index);
    emit(newThemeMode);
  }
}
