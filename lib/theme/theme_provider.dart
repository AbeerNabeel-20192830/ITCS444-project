import 'package:flutter/material.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool initialIsDarkMode = true;
  ThemeData _themeData;

  ThemeData get themeData => _themeData;

  ThemeProvider(bool isDarkMode)
      : _themeData = isDarkMode ? darkMode : lightMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    bool isDarkMode = (themeData == darkMode);
    themeData = isDarkMode ? lightMode : darkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', !isDarkMode);
    notifyListeners();
  }
}
