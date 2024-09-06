import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends ChangeNotifier {
  var thememode = ThemeMode.dark;

  // ThemeMode get themeData {
  //   return thememode;
  // }

  bool _isDark = true;

  bool get isDark {
    return _isDark;
  }

  void changeTheme() {
    if (_isDark) {
      thememode = ThemeMode.light;
      _isDark = false;
    } else {
      thememode = ThemeMode.dark;
      _isDark = true;
    }
    notifyListeners();
  }
}

final themeProvider = ChangeNotifierProvider<ThemeNotifier>(
  (ref) => ThemeNotifier(),
);
