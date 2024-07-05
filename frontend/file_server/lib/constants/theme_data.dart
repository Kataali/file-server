import 'package:flutter/material.dart';

ThemeData themeData() {
  return ThemeData(
    useMaterial3: true,
    // scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(235, 238, 239, 1.0),
    colorScheme: ThemeData().colorScheme.copyWith(
        primary: const Color.fromARGB(255, 156, 208, 171),
        onPrimary: const Color.fromRGBO(255, 255, 255, 1),
        onSurface: Colors.grey,
        secondary: const Color.fromRGBO(29, 30, 32, 1),
        onSecondary: const Color.fromARGB(255, 177, 29, 29),
        surface: const Color.fromRGBO(245, 246, 250, 1),
        tertiary: const Color.fromRGBO(235, 238, 239, 1.0),
        onTertiary: const Color.fromARGB(255, 97, 97, 97)),
  );
}
