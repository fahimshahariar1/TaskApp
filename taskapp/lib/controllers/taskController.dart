import 'package:get/get.dart';
import 'package:taskapp/db/dbHelper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onInit() {
    getTasks(); // Move the initialization logic to onInit instead of onReady
    super.onInit();
  }

  Future<int?> addTask({required Task task}) async {
    return DbHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DbHelper.delete(task);
    getTasks();
  }

  Future<void> markTaskCompleted(int id) async {
    await DbHelper.update(id);
    getTasks();
  }
}
