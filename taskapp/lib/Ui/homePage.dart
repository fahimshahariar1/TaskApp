import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:taskapp/services/notificationServices.dart';
import 'package:taskapp/services/themeServices.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});



  @override
  State<HomePage> createState() => _HomePageState();




}

class _HomePageState extends State<HomePage> {

  var _notifyHelper;
  @override
  void initState(){
    super.initState();
    _notifyHelper=NotifyHelper();
    _notifyHelper.initializeNotification();
    _notifyHelper.requestIOSPermissions();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [Center(child: Text("TaskApp"))],
      ),
    );
  }


  _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          _notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode?"Light Mode on":"Dark Mode on"
          );
        },
        child: Icon(
          Icons.nightlight_round,
          size: 20,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
        )
      ],
    );
  }
}