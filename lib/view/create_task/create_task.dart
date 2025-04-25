import 'package:flutter/material.dart';
import 'package:flutter_application_1/view_model/Dummy_notification.dart';
import 'package:flutter_application_1/view_model/create_task_helper.dart';
import 'package:flutter_application_1/view_model/homepage_controller.dart';
import 'package:flutter_application_1/view_model/notification_controller.dart';
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
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    if (widget.isedit) {
      final editnote = HomepageController.myBox.get(widget.editkey);
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstnats.backgroundColor,
        title: Text(
          widget.isedit ? "Update task" : "Add New Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstnats.primarywhite,
            fontSize: isSmallScreen ? 20 : 24,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Task Title"),
                SizedBox(height: isSmallScreen ? 8.0 : 12.0),
                _buildTextFormField(
                  controller: title_controller,
                  label: "Task Title",
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a title' : null,
                ),
                SizedBox(height: isSmallScreen ? 16.0 : 20.0),
                _buildSectionTitle("Category"),
                SizedBox(height: isSmallScreen ? 8.0 : 12.0),
                _buildCategorySelector(isSmallScreen),
                SizedBox(height: isSmallScreen ? 16.0 : 20.0),
                _buildDateTimeRow(isSmallScreen),
                SizedBox(height: isSmallScreen ? 20.0 : 24.0),
                _buildSectionTitle("Notes"),
                SizedBox(height: isSmallScreen ? 5.0 : 8.0),
                _buildNotesField(),
                SizedBox(height: isSmallScreen ? 60.0 : 80.0),
                _buildSaveButton(isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
    );
  }

  Widget _buildCategorySelector(bool isSmallScreen) {
    return Container(
      height: isSmallScreen ? 64 : 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: context.read<HomepageController>().imageList.length,
        separatorBuilder: (context, index) => SizedBox(
          width: isSmallScreen ? 20 : 24,
        ),
        itemBuilder: (context, index) => InkWell(
          onTap: () => setState(() => selectedImage = index),
          child: CircleAvatar(
            radius: isSmallScreen ? 32 : 36,
            backgroundColor:
                selectedImage == index ? ColorConstnats.backgroundColor : null,
            child: CircleAvatar(
              radius: isSmallScreen ? 30 : 34,
              backgroundImage: AssetImage(
                context.read<HomepageController>().imageList[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow(bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        children: [
          _buildDateField(),
          SizedBox(height: isSmallScreen ? 16.0 : 20.0),
          _buildTimeField(),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _buildDateField()),
        SizedBox(width: isSmallScreen ? 16.0 : 20.0),
        Expanded(child: _buildTimeField()),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Date"),
        SizedBox(height: 8.0),
        _buildTextFormField(
          controller: date_controller,
          label: "Date",
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please select date' : null,
          readOnly: true,
          onTap: () => CreateTaskHelper.selectDate(
            context,
            date_controller,
            (date) => selectedDate = date,
          ),
          suffixIcon: Icon(Icons.date_range_outlined),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Time"),
        SizedBox(height: 8.0),
        _buildTextFormField(
          controller: time_controller,
          label: "Time",
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please select time' : null,
          readOnly: true,
          onTap: () => CreateTaskHelper.selectTime(context, time_controller),
          suffixIcon: Icon(Icons.access_time_outlined),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return _buildTextFormField(
      controller: note_controller,
      label: "Notes",
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please enter notes' : null,
      maxLines: 3,
    );
  }

  Widget _buildSaveButton(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 40.0 : 100.0),
      child: InkWell(
        onTap: _handleSave,
        child: Container(
          height: isSmallScreen ? 50 : 60,
          decoration: BoxDecoration(
            color: ColorConstnats.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              "Save",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConstnats.primarywhite,
                fontSize: isSmallScreen ? 16 : 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!CreateTaskHelper.validateForm(
      _formKey,
      title_controller,
      date_controller,
      time_controller,
      note_controller,
    )) return;

    if (widget.isedit) {
      context.read<HomepageController>().editNoteList(
            title: title_controller.text,
            date: date_controller.text,
            time: time_controller.text,
            reason: note_controller.text,
            imageIndex: selectedImage,
            key: widget.editkey,
          );
    } else {
      context.read<DummyController>().scheduleNotification(
            0,
            "show something",
            "boby of notification",
            date_controller.text,
            time_controller.text,
          );

      await context.read<HomepageController>().addNote(
            title: title_controller.text,
            date: date_controller.text,
            time: time_controller.text,
            reason: note_controller.text,
            imageIndex: selectedImage,
          );

      context.read<NotificationController>().scheduleNotification(
            0,
            'Scheduled Notification',
            'This is a test notification',
            DateTime.now().add(Duration(seconds: 5)),
          );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigation()),
    );
  }
}
