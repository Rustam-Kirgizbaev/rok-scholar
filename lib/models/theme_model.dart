import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

enum AppThemeEnum {
  light,
  dark,
}

class ThemeModel extends ChangeNotifier {
  static const _themeKey = 'appTheme';

  ThemeData _currentTheme = AppTheme.lightTheme;
  AppThemeEnum _appTheme = AppThemeEnum.light;

  ThemeData get currentTheme => _currentTheme;
  AppThemeEnum get appTheme => _appTheme;

  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  bool _advancedSearchEnabled = false;
  bool get advancedSearchEnabled => _advancedSearchEnabled;

  ThemeModel() {
    _loadTheme();
    _loadLocale();
    _loadSearchOption();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppThemeEnum savedTheme = AppThemeEnum.values[prefs.getInt(_themeKey) ?? 0];
    _setTheme(savedTheme);
  }

  void _setTheme(AppThemeEnum theme) {
    _appTheme = theme;
    if (_appTheme == AppThemeEnum.light) {
      _currentTheme = AppTheme.lightTheme;
    } else {
      _currentTheme = AppTheme.darkTheme;
    }
    notifyListeners();
  }

  void toggleTheme() async {
    AppThemeEnum newTheme = _appTheme == AppThemeEnum.light
        ? AppThemeEnum.dark
        : AppThemeEnum.light;
    _setTheme(newTheme);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themeKey, newTheme.index);
  }

  void _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
    }
    notifyListeners();
  }

  void _saveLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', _currentLocale.languageCode);
  }

  void setLocale(Locale? newLocale) async {
    _currentLocale = newLocale ?? const Locale('en');
    _saveLocale();
    notifyListeners();
  }

  void _loadSearchOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? searchOption = prefs.getBool('searchOption');
    if (searchOption != null) {
      _advancedSearchEnabled = searchOption;
    }
    notifyListeners();
  }

  void _saveSearchOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('searchOption', _advancedSearchEnabled);
  }

  void setSearchOption(bool? newSearchOption) async {
    _advancedSearchEnabled = newSearchOption ?? false;
    _saveSearchOption();
    notifyListeners();
  }
}
