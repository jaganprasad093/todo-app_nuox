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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: ColorConstnats.backgroundColor,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: .2),
        title: Text(
          "My Todo List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstnats.primarywhite,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(70),
        //   ),
        // ),
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
        child: const Icon(Icons.add, color: Colors.white),
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
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No tasks yet",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstnats.backgroundColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
                        child: const Text(
                          "Add New Task",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
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
                              const SizedBox(height: 20),
                          itemCount: HomepageController.notelistKeys.length,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
