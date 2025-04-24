import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/homepage_controller.dart';
import 'package:flutter_application_1/core/constants/color_constnats.dart';
import 'package:flutter_application_1/view/create_task/create_task.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatefulWidget {
  final String title;
  final String time;
  final String date;
  final String reason;
  final int imageIndex;
  final int index;

  const TodoCard({
    super.key,
    required this.title,
    required this.time,
    required this.date,
    required this.reason,
    required this.imageIndex,
    required this.index,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      color: ColorConstnats.primarywhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[100],
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(
                            context
                                .read<HomepageController>()
                                .imageList[widget.imageIndex],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${widget.date} • ${widget.time}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1.5,
                          ),
                          value: HomepageController.donelist[widget.index],
                          onChanged: (value) async {
                            setState(() {
                              context.read<HomepageController>().removelist(
                                    widget.index,
                                    value!,
                                    HomepageController
                                        .notelistKeys[widget.index],
                                  );
                            });
                          },
                        ),
                      ),
                      _buildPopupMenu(),
                    ],
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.notes_outlined,
                      size: 18,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.reason,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey[600],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onSelected: (value) async {
        if (value == 'delete') {
          context
              .read<HomepageController>()
              .deleteListnote(HomepageController.notelistKeys[widget.index]);
        } else if (value == 'edit') {
          final currentKey = HomepageController.notelistKeys[widget.index];
          final currentElement = HomepageController.myBox.get(currentKey);

          if (currentElement != null) {
            await context.read<HomepageController>().editNoteList(
                  key: currentKey,
                  imageIndex: currentElement["imageIndex"] ?? 0,
                  title: currentElement["title"],
                  date: currentElement["date"],
                  reason: currentElement["reason"] ?? "No description",
                  time: currentElement["time"],
                );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTask(
                  isedit: true,
                  editkey: currentKey,
                ),
              ),
            );
          }
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: const [
                Icon(Icons.edit, size: 20),
                SizedBox(width: 8),
                Text("Edit"),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20, color: Colors.red[400]),
                const SizedBox(width: 8),
                Text(
                  "Delete",
                  style: TextStyle(color: Colors.red[400]),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
