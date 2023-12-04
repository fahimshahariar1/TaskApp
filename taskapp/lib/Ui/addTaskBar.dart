import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/Ui/theme.dart';
import 'package:taskapp/Ui/widgets/button.dart';
import 'package:taskapp/Ui/widgets/inputField.dart';
import 'package:taskapp/controllers/taskController.dart';
import 'package:taskapp/models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final TaskController taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String endTime = "9:30 AM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  String selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headinStyle,
              ),
               MyInputField(
                title: "Title",
                hint: "Enter Your Title",
                controller: _titleController,
              ),
               MyInputField(
                title: 'Task',
                hint: 'Enter Your Task',
                controller: _noteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(selectedDate),
                widget: IconButton(
                  onPressed: () {
                    getDateFromUser();
                  },
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                          title: "Start Time",
                          hint: startTime,
                          widget: IconButton(
                              onPressed: () {
                                getTimeFromUser(isStartTime: true);
                              },
                              icon: Icon(Icons.access_time_rounded)))),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: MyInputField(
                          title: "End Time",
                          hint: endTime,
                          widget: IconButton(
                              onPressed: () {
                                getTimeFromUser(isStartTime: false);
                              },
                              icon: Icon(Icons.access_time_rounded)))),
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$selectedRemind minutes early",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>(
                    (int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedRemind = int.parse(value!);
                    });
                  },
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: "$selectedRepeat",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitleStyle,
                  items: repeatList.map<DropdownMenuItem<String>>(
                    (value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedRepeat = value!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  colorPallete(),
                  MyButton("Create Task", () => validateData()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "Missing Fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(Icons.warning_amber_outlined, color: pinkClr,));
    }
  }

  colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(
          height: 8,
        ),
        Wrap(
            children: List<Widget>.generate(3, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : yellowClr,
                child: selectedColor == index
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      )
                    : Container(),
              ),
            ),
          );
        })),
      ],
    );
  }


  addTaskToDb() async{
   await taskController.addTask(
        task: Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(selectedDate),
            startTime: startTime,
            endTime: endTime,
            remind: selectedRemind,
            repeat: selectedRepeat,
            isCompleted: 0
        )
    );
  }


  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new)),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/f.png"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        initialDate: DateTime.now(),
        context: context,
        firstDate: DateTime(2015),
        lastDate: DateTime(2024));

    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
      });
    } else {}
  }

  getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String formatedTime = pickedTime.format(context);

    if (pickedTime == null) {
    } else if (isStartTime == true) {
      setState(() {
        startTime = formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        endTime = formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: int.parse(startTime.split(":")[0]),
        minute: int.parse(startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
