import 'package:flutter/material.dart';

// final ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: Colors.blue,
//   hintColor: Colors.green,
// );
//
// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: Colors.black,
//   hintColor: Colors.yellow,
// );

class Translations {
  static Map<String, String> fr = {
    'title': 'Titre',
    'settings': 'Paramètres',
    'language': 'Langue',
  };

  static Map<String, String> en = {
    'title': 'Title',
    'settings': 'Settings',
    'language': 'Language',
  };

  static Map<String, String> es = {
    'title': 'Título',
    'settings': 'Ajustes',
    'language': 'Idioma',
  };
}

enum ThemeType {
  light,
  dark,
  custom1,
  custom2,
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  hintColor: Colors.green,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  hintColor: Colors.yellow,
);

final ThemeData custom1Theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.purple,
  hintColor: Colors.orange,
);

final ThemeData custom2Theme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.pink,
  hintColor: Colors.teal,
);