import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/Dummy_notification.dart';
import 'package:flutter_application_1/controller/controller_1.dart';
import 'package:flutter_application_1/controller/homepage_controller.dart';
import 'package:flutter_application_1/controller/notification_controller.dart';
import 'package:flutter_application_1/core/constants/color_constnats.dart';
import 'package:flutter_application_1/view/bottom_navigation/bottom_navigation.dart';
import 'package:provider/provider.dart';

class CreateTask extends StatefulWidget {
  final bool isedit;
  final editkey;

  const CreateTask({super.key, required this.isedit, this.editkey});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController title_controller = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  TextEditingController time_controller = TextEditingController();
  TextEditingController note_controller = TextEditingController();
  int selectedImage = 0;

  @override
  void initState() {
    if (widget.isedit == true) {
      final editnote = HomepageController.myBox.get(widget.editkey);

      // String savedTitle = HomepageController.myBox.get("title") ?? "";
      // String savedDate = HomepageController.myBox.get("date") ?? "";
      // String savedTime = HomepageController.myBox.get("time") ?? "";
      // String savedReason = HomepageController.myBox.get("reason") ?? "";
      // String savedImageIndex =
      //     HomepageController.myBox.get("imageIndex", defaultValue: "");
      time_controller.text = editnote["time"] ?? "";
      title_controller.text = editnote["title"] ?? "";
      date_controller.text = editnote["date"] ?? "";
      note_controller.text = editnote["reason"] ?? "";
      selectedImage = editnote['imageIndex'] ?? 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstnats.backgroundColor,
        title: Text(
          widget.isedit == true ? "Update task" : "Add New Task",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorConstnats.primarywhite),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Title",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: title_controller,
                    decoration: InputDecoration(
                      labelText: "Task Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSaved: (String? value) {},
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'Please enter a title'
                          : null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Category",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 64,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          setState(() {});
                          selectedImage = index;
                        },
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: selectedImage == index
                              ? ColorConstnats.backgroundColor
                              : null,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              context
                                  .read<HomepageController>()
                                  .imageList[index],
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 20,
                      ),
                      itemCount:
                          context.read<HomepageController>().imageList.length,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              onTap: () => _selectDate(context),
                              controller: date_controller,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Date",
                                suffixIcon: Icon(Icons.date_range_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onSaved: (String? value) {},
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? 'Please select date'
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Time",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: time_controller,
                              readOnly: true,
                              onTap: () => _selectTime(context),
                              decoration: InputDecoration(
                                labelText: "Time",
                                suffixIcon: Icon(Icons.access_time_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onSaved: (String? value) {},
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? 'Please select time'
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Notes",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: note_controller,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                      labelText: "Notes",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSaved: (String? value) {},
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'Please note'
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  InkWell(
                    onTap: () async {
                      if (widget.isedit == true) {
                        if (_formKey.currentState!.validate()) {
                          context.read<HomepageController>().editNoteList(
                              title: title_controller.text,
                              date: date_controller.text,
                              time: time_controller.text,
                              reason: note_controller.text,
                              imageIndex: selectedImage,
                              key: widget.editkey);
                          log("data updated to hive");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavigation(),
                              ));
                          log("updated element:${HomepageController.myBox.get(widget.editkey)}");
                        }
                      } else {
                        final notifcationcontriollere = NotificationService();
                        notifcationcontriollere.scheduleNotification(
                            title: "show something",
                            body: "sow curret ",
                            scheduledNotificationDateTime:
                                DateTime.now().add(Duration(minutes: 1)));

                        // if (_formKey.currentState!.validate()) {
                        //   context.read<DummyController>().scheduleNotification(
                        //       0,
                        //       "show something",
                        //       "boby of notification",
                        //       date_controller.text,
                        //       time_controller.text);
                        //   log("date:${date_controller.text}");
                        //   log("date:${time_controller.text}");
                        //   log("notification send");
                        //   await context.read<HomepageController>().addNote(
                        //       title: title_controller.text,
                        //       date: date_controller.text,
                        //       time: time_controller.text,
                        //       reason: note_controller.text,
                        //       imageIndex: selectedImage);
                        //   context.read<HomepageController>().getinikey();
                        //   log("image index:$selectedImage");
                        //   log("data added to hive");
                        //   Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => BottomNavigation(),
                        //       ));
                        // }

                        // context
                        //     .read<NotificationController>()
                        //     .scheduleNotification(
                        //       0,
                        //       'Scheduled Notification',
                        //       'This is a test notification',
                        //       DateTime.now().add(Duration(seconds: 5)),
                        //     );
                        //}
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: ColorConstnats.backgroundColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstnats.primarywhite),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date_controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final format = "${picked.hour}:${picked.minute}";
      setState(() {
        time_controller.text = format;
      });
    }
  }

  DateTime selectedDate = DateTime.now();
}
