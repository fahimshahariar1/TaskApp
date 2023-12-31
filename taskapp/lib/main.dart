import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taskapp/Ui/homePage.dart';
import 'package:taskapp/db/dbHelper.dart';
import 'package:taskapp/services/themeServices.dart';

import 'Ui/theme.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();
  await GetStorage.init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task App',
      theme: Themes.light,

      themeMode: ThemeServices().theme,
      darkTheme: Themes.dark,

      home: HomePage(),
    );
  }
}
