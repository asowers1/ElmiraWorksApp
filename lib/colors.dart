import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomColors {
  static Color lightColor = const Color(0xFFd1e4dd);
  static Color darkColor = const Color(0xFF28303d);
  static Color get themeColor {
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode ? darkColor : lightColor;
  }

  static Color contextThemeColor(context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode ? darkColor : lightColor;
  }

  static Color contextOnThemeColor(context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode ? lightColor : darkColor;
  }
}
