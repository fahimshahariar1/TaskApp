import 'package:get/get.dart';
import 'package:taskapp/db/dbHelper.dart';

import '../models/task.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

Future<Future<int?>> addTask({Task? task})async {
    return DbHelper.insert(task);
}


}