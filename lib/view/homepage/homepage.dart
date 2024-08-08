import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/Dummy_notification.dart';
import 'package:flutter_application_1/controller/homepage_controller.dart';
import 'package:flutter_application_1/controller/notification_controller.dart';
import 'package:flutter_application_1/core/constants/color_constnats.dart';
import 'package:flutter_application_1/view/create_task/create_task.dart';
import 'package:flutter_application_1/view/widgets/todo_card.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // context.read<NotificationController>().initializeNotification();
    context.read<DummyController>().init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomepageController>().getinikey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstnats.backgroundColor,
        title: Text(
          "My Todo List",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorConstnats.primarywhite),
        ),
      ),
      body: Consumer<HomepageController>(
        builder: (context, controller, child) {
          return HomepageController.notelistKeys.isEmpty
              ? Center(
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTask(
                            isedit: false,
                          ),
                        ),
                      );
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
                            "Add New Task",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstnats.primarywhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final currentKey =
                              HomepageController.notelistKeys[index];
                          dynamic currentElement =
                              HomepageController.myBox.get(currentKey);

                          if (currentElement is! Map) {
                            // log("Unexpected data type in myBox for key $currentKey: $currentElement");
                            return Container();
                          }

                          return TodoCard(
                            index: index,
                            imageIndex: currentElement["imageIndex"] ?? 0,
                            title: currentElement["title"] ?? "",
                            date: currentElement["date"] ?? "",
                            reason: currentElement["reason"] ?? "no reason",
                            time: currentElement["time"] ?? "",
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 20),
                        itemCount: HomepageController.notelistKeys.length,
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                );
        },
      ),
    );
  }
}
