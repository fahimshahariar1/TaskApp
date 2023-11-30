import 'package:flutter/material.dart';
import 'package:taskapp/Ui/homePage.dart';

import 'Ui/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task App',
      theme: Themes.light,

      themeMode: ThemeMode.dark,
      darkTheme: Themes.dark,

      home: HomePage(),
    );
  }
}
