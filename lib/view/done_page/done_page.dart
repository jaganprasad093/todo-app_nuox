import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/view_model/homepage_controller.dart';
import 'package:flutter_application_1/core/constants/color_constnats.dart';
import 'package:flutter_application_1/view/widgets/donecard.dart';
import 'package:provider/provider.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomepageController>().getinikey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstnats.primarywhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstnats.backgroundColor,
        title: Text(
          "Completed Task",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorConstnats.primarywhite),
        ),
      ),
      body: Consumer<HomepageController>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: HomepageController.completedKeys.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No tasks compeleted yet",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    final currentKey = HomepageController.completedKeys[index];
                    final currentElement =
                        HomepageController.completedBox.get(currentKey);

                    log("completed list--------------------${HomepageController.completedKeys.length}");
                    log("completed list---------------${currentElement}");
                    return Donecard(
                      index: index,
                      imageIndex: currentElement["imageIndex"] ?? 0,
                      title: currentElement["title"] ?? "",
                      date: currentElement["date"] ?? "",
                      reason: currentElement["reason"] ?? "no reason",
                      time: currentElement["time"] ?? "",
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  itemCount: HomepageController.completedKeys.length),
        ),
      ),
    );
  }
}
