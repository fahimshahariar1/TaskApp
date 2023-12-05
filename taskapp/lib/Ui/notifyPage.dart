import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/Ui/theme.dart';

class NotifyPage extends StatelessWidget {
  final String? label;

  const NotifyPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      // Handle the case where label is null
      return Scaffold(
        body: Center(
          child: Text('Invalid data'),
        ),
      );
    }

    List<String> labelParts = label!.split("|");
    if (labelParts.length != 2) {
      // Handle the case where label doesn't contain two parts
      return Scaffold(
        body: Center(
          child: Text('Invalid data format'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(labelParts[0]),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primaryClr,
          ),
          child: Center(
            child: Text(
              labelParts[1],
              style: TextStyle(
                color: Get.isDarkMode ? Colors.black : Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
