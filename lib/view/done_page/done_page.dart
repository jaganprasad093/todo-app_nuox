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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    // Responsive sizing factors
    final double appBarFontSize = isSmallScreen ? 20 : 24;
    final double emptyStateIconSize = screenHeight * 0.12;
    final double emptyStateTextSize = screenHeight * 0.022;
    final double pagePadding = screenWidth * 0.02;
    final double itemSpacing = screenHeight * 0.015;

    return Scaffold(
      backgroundColor: ColorConstnats.primarywhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstnats.backgroundColor,
        title: Text(
          "Completed Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstnats.primarywhite,
            fontSize: appBarFontSize,
          ),
        ),
      ),
      body: Consumer<HomepageController>(
        builder: (context, value, child) => Padding(
          padding: EdgeInsets.all(pagePadding),
          child: HomepageController.completedKeys.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: emptyStateIconSize,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        "No tasks completed yet",
                        style: TextStyle(
                          fontSize: emptyStateTextSize,
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
                        height: itemSpacing,
                      ),
                  itemCount: HomepageController.completedKeys.length),
        ),
      ),
    );
  }
}
