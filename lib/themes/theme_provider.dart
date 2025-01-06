
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/themes/dark_mode.dart';
import 'package:musicplayer/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially, light mode
  ThemeData _themeData = lightMode;

  // Get the current theme
  ThemeData get themeData => _themeData;

  // Check if dark mode is active
  bool get isDarkMode => _themeData == darkMode;

  // Set the theme and notify listeners
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Properly notify listeners when the theme changes
  }

  // Toggle between light and dark modes
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
