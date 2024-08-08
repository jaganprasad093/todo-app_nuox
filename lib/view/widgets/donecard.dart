import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/homepage_controller.dart';
import 'package:flutter_application_1/core/constants/color_constnats.dart';
import 'package:provider/provider.dart';

class Donecard extends StatefulWidget {
  final String title;
  final String time;
  final String date;
  final String reason;
  int imageIndex = 0;
  int index;

  Donecard(
      {super.key,
      required this.title,
      required this.time,
      required this.date,
      required this.reason,
      required this.imageIndex,
      required this.index});

  @override
  State<Donecard> createState() => _DonecardState();
}

class _DonecardState extends State<Donecard> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomepageController>().getinikey();
    });
    super.initState();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<HomepageController>().getinikey();
  //   });
  // }

  // static bool done = HomepageController.done;
  @override
  Widget build(BuildContext context) {
    log("message:${HomepageController.completedKeys}");
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(context
                        .read<HomepageController>()
                        .imageList[widget.imageIndex]),
                    radius: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title),
                      Text(widget.time),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: HomepageController.backlist[widget.index],
                    onChanged: (value) async {
                      log("length--- ${widget.index}");
                      // HomepageController.done = value!;
                      context.read<HomepageController>().returnlist(
                          widget.index,
                          value!,
                          HomepageController.completedKeys[widget.index]);
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'delete') {
                        context.read<HomepageController>().deleteListcomplete(
                            HomepageController.completedKeys[widget.index]);
                        // context.read<HomepageController>().deleteAllNotes();
                        log("deleted");
                      }
                      // } else if (value == 'edit') {
                      //   final currentKey =
                      //       HomepageController.completedKeys[widget.index];
                      //   final currentElement =
                      //       HomepageController.compeletedBox.get(currentKey);
                      //   log("current element of ----- ${currentElement}");
                      //   await context.read<HomepageController>().editNoteList(
                      //         key: currentKey,
                      //         imageIndex: currentElement["imageIndex"] ?? 0,
                      //         title: currentElement["title"],
                      //         date: currentElement["date"],
                      //         reason: currentElement["reason"] ?? "no reason",
                      //         time: currentElement["time"],
                      //       );
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => CreateTask(
                      //         isedit: true,
                      //         editkey: currentKey,
                      //       ),
                      //     ),
                      //   );
                      // }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text("delete"),
                        ),
                        // PopupMenuItem(
                        //   value: 'edit',
                        //   child: Text("Not compeleted"),
                        // ),
                      ];
                    },
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: ColorConstnats.primaryBlack,
            height: .1,
            width: 400,
          )
        ],
      ),
    );
  }
}
