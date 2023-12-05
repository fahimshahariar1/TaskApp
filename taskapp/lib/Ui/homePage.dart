import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/Ui/addTaskBar.dart';
import 'package:taskapp/Ui/theme.dart';
import 'package:taskapp/Ui/widgets/button.dart';
import 'package:taskapp/Ui/widgets/taskTile.dart';
import 'package:taskapp/controllers/taskController.dart';
import 'package:taskapp/services/notificationServices.dart';
import 'package:taskapp/services/themeServices.dart';

import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final taskController = Get.put(TaskController());
  var _notifyHelper;

  @override
  void initState() {
    super.initState();
    _notifyHelper = NotifyHelper();
    _notifyHelper.initializeNotification();
    _notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          addTaskBar(),
          addDateBar(),
          const SizedBox(
            height: 15,
          ),
          showTasks(),
        ],
      ),
    );
  }


  // showTasks() {
  //   return Expanded(
  //       child: Obx(() {
  //         return ListView.builder(
  //             itemCount: taskController.taskList.length,
  //             itemBuilder: (_, index) {
  //               Task task = taskController.taskList[index];
  //
  //               if (task.repeat == "Daily") {
  //                 _scheduleDailyNotification(task);
  //               }
  //
  //               return AnimationConfiguration.staggeredList(
  //                 position: index,
  //                 child: SlideAnimation(
  //                   child: FadeInAnimation(
  //                     child: Row(
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             _showBottomSheet(context, task);
  //                           },
  //                           child: TaskTile(task),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),);
  //             } else if (task.date == DateFormat.yMd().format(selectedDate)) {
  //         return AnimationConfiguration.staggeredList(
  //         position: index,
  //         child: SlideAnimation(
  //         child: FadeInAnimation(
  //         child: Row(
  //         children: [
  //         GestureDetector(
  //         onTap: () {
  //         _showBottomSheet(context, task);
  //         },
  //         child: TaskTile(task),),],),),),);
  //         } else {
  //         return Container();
  //         }
  //
  //         ,
  //         );
  //       }
  //
  //       )
  //
  //   );
  // }

  showTasks() {
    return Expanded(
      child: Obx(
            () {
          return ListView.builder(
            itemCount: taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = taskController.taskList[index];

              if (task.repeat == "Daily") {
                _scheduleDailyNotification(task);
              }

              if (task.date == DateFormat.yMd().format(selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }



  void _scheduleDailyNotification(Task task) {
    String? formattedStartTime = task.startTime?.trim();
    if (formattedStartTime == null ||
        !formattedStartTime.endsWith("AM") &&
            !formattedStartTime.endsWith("PM")) {
      print("Invalid startTime format: $formattedStartTime");
      return;
    }

    int? hour = int.tryParse(formattedStartTime.substring(0, 2));
    int? minutes = int.tryParse(formattedStartTime.substring(3, 5));

    if (hour == null || minutes == null) {
      print("Invalid startTime format: $formattedStartTime");
      return;
    }

    if (hour < 0 || hour > 23 || minutes < 0 || minutes > 59) {
      print("Invalid startTime value: $formattedStartTime");
      return;
    }

    DateTime startTime = DateFormat("hh:mm a").parse(formattedStartTime);
    int hours = startTime.hour;
    int minutesTask = startTime.minute;

    _notifyHelper.scheduledNotification(
      hours,
      minutesTask,
      task,
    );
  }


  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery
            .of(context)
            .size
            .height * 0.24
            : MediaQuery
            .of(context)
            .size
            .height * 0.32,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : bottomSheetButton(
              label: "Task Completed",
              onTap: () {
                taskController.markTaskCompleted(task.id!);
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),
            const SizedBox(
              height: 8,
            ),
            bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                taskController.delete(task);
                taskController.getTasks();
                Get.back();
              },
              clr: Colors.red.shade300,
              context: context,
            ),
            const SizedBox(
              height: 30,
            ),
            bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red.shade300,
              isClosed: true,
              context: context,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClosed = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        height: 55,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        decoration: BoxDecoration(
          color: isClosed == true ? Colors.transparent : clr,
          border: Border.all(
            width: 2,
            color: isClosed == true
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
              label,
              style:
              isClosed ? titleStyle : titleStyle.copyWith(color: Colors.white),
            )),
      ),
    );
  }

  addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

  addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadinStyle,
              ),
              Text(
                "Today",
                style: headinStyle,
              )
            ],
          ),
          MyButton(
            "+ Add Task",
                () async {
              await Get.to(const AddTaskPage());
              taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          _notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode ? "Light Mode on" : "Dark Mode on");
        },
        child: Icon(
          Get.isDarkMode ? Icons.sunny : Icons.nightlight_round,
          size: 20,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/f.png"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

