import 'package:flutter/material.dart';
import 'package:flutter_application_1/view_model/Dummy_notification.dart';
import 'package:flutter_application_1/view_model/homepage_controller.dart';
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
    context.read<DummyController>().init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomepageController>().getinikey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final double appBarFontSize = isSmallScreen ? 22 : 24;
    final double emptyStateIconSize = isSmallScreen ? 80 : 100;
    final double emptyStateTextSize = isSmallScreen ? 18 : 20;
    final double buttonHorizontalPadding = isSmallScreen ? 30 : 40;
    final double buttonVerticalPadding = isSmallScreen ? 12 : 16;
    final double buttonBorderRadius = isSmallScreen ? 20 : 25;
    final double listHorizontalPadding = screenWidth * 0.04;
    final double listItemSpacing = isSmallScreen ? 20 : 25;
    final double topPadding = screenHeight * 0.02;
    final double bottomPadding = screenHeight * 0.02;
    final double fabSize = isSmallScreen ? 56 : 64;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstnats.backgroundColor,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: .2),
        title: Text(
          "My Todo List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstnats.primarywhite,
            fontSize: appBarFontSize,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstnats.backgroundColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTask(isedit: false),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white, size: fabSize * 0.5),
        mini: false,
        elevation: 4,
        shape: CircleBorder(),
      ),
      body: Consumer<HomepageController>(
        builder: (context, controller, child) {
          return HomepageController.notelistKeys.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: emptyStateIconSize,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "No tasks yet",
                        style: TextStyle(
                          fontSize: emptyStateTextSize,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstnats.backgroundColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: buttonHorizontalPadding,
                            vertical: buttonVerticalPadding,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(buttonBorderRadius),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateTask(
                                isedit: false,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Add New Task",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: emptyStateTextSize * 0.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: listHorizontalPadding),
                  child: Column(
                    children: [
                      SizedBox(height: topPadding),
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final currentKey =
                                HomepageController.notelistKeys[index];
                            dynamic currentElement =
                                HomepageController.myBox.get(currentKey);

                            if (currentElement is! Map) {
                              return Container();
                            }

                            return TodoCard(
                              index: index,
                              imageIndex: currentElement["imageIndex"] ?? 0,
                              title: currentElement["title"] ?? "",
                              date: currentElement["date"] ?? "",
                              reason:
                                  currentElement["reason"] ?? "No description",
                              time: currentElement["time"] ?? "",
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: listItemSpacing),
                          itemCount: HomepageController.notelistKeys.length,
                        ),
                      ),
                      SizedBox(height: bottomPadding),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
