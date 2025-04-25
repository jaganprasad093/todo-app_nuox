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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final double paddingFactor = isSmallScreen ? 0.04 : 0.03;
    final double spacingFactor = isSmallScreen ? 0.02 : 0.025;
    final double avatarRadiusFactor = isSmallScreen ? 0.07 : 0.06;
    final double buttonHeightFactor = isSmallScreen ? 0.06 : 0.065;
    final double buttonHorizontalPaddingFactor = isSmallScreen ? 0.1 : 0.2;
    final double fontSizeFactor = isSmallScreen ? 0.04 : 0.035;

    return Scaffold(
      backgroundColor: ColorConstnats.primarywhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstnats.backgroundColor,
        title: Text(
          widget.isedit ? "Update task" : "Add New Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstnats.primarywhite,
            fontSize: screenWidth * fontSizeFactor,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * paddingFactor),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Task Title", screenWidth),
                SizedBox(height: screenHeight * spacingFactor),
                _buildTextFormField(
                  controller: title_controller,
                  label: "Task Title",
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a title' : null,
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * spacingFactor * 1),
                _buildSectionTitle("Category", screenWidth),
                SizedBox(height: screenHeight * spacingFactor),
                _buildCategorySelector(screenWidth, avatarRadiusFactor),
                SizedBox(height: screenHeight * spacingFactor * .1),
                _buildDateTimeRow(screenWidth, screenHeight, isSmallScreen),
                SizedBox(height: screenHeight * spacingFactor * 1),
                _buildSectionTitle("Notes", screenWidth),
                SizedBox(height: screenHeight * spacingFactor * 0),
                _buildNotesField(screenWidth),
                SizedBox(height: screenHeight * 0.07),
                _buildSaveButton(screenWidth, screenHeight, buttonHeightFactor,
                    buttonHorizontalPaddingFactor, fontSizeFactor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenWidth * 0.04,
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
    required double screenWidth,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
    );
  }

  Widget _buildCategorySelector(double screenWidth, double avatarRadiusFactor) {
    return Container(
      height: screenWidth * 0.2,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: context.read<HomepageController>().imageList.length,
        separatorBuilder: (context, index) => SizedBox(
          width: screenWidth * 0.05,
        ),
        itemBuilder: (context, index) => InkWell(
          onTap: () => setState(() => selectedImage = index),
          child: CircleAvatar(
            radius: screenWidth * avatarRadiusFactor,
            backgroundColor:
                selectedImage == index ? ColorConstnats.backgroundColor : null,
            child: CircleAvatar(
              radius: screenWidth * (avatarRadiusFactor - 0.005),
              backgroundImage: AssetImage(
                context.read<HomepageController>().imageList[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow(
      double screenWidth, double screenHeight, bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        children: [
          _buildDateField(screenWidth, screenHeight),
          SizedBox(height: screenHeight * 0.02),
          _buildTimeField(screenWidth, screenHeight),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _buildDateField(screenWidth, screenHeight)),
        SizedBox(width: screenWidth * 0.04),
        Expanded(child: _buildTimeField(screenWidth, screenHeight)),
      ],
    );
  }

  Widget _buildDateField(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Date", screenWidth),
        SizedBox(height: screenHeight * 0.01),
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
          screenWidth: screenWidth,
        ),
      ],
    );
  }

  Widget _buildTimeField(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Time", screenWidth),
        SizedBox(height: screenHeight * 0.01),
        _buildTextFormField(
          controller: time_controller,
          label: "Time",
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please select time' : null,
          readOnly: true,
          onTap: () => CreateTaskHelper.selectTime(context, time_controller),
          suffixIcon: Icon(Icons.access_time_outlined),
          screenWidth: screenWidth,
        ),
      ],
    );
  }

  Widget _buildNotesField([double? screenWidth]) {
    return _buildTextFormField(
      controller: note_controller,
      label: "Notes",
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please enter notes' : null,
      maxLines: 3,
      screenWidth: screenWidth ?? MediaQuery.of(context).size.width,
    );
  }

  Widget _buildSaveButton(
      double screenWidth,
      double screenHeight,
      double buttonHeightFactor,
      double buttonHorizontalPaddingFactor,
      double fontSizeFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * buttonHorizontalPaddingFactor),
      child: InkWell(
        onTap: _handleSave,
        child: Container(
          height: screenHeight * buttonHeightFactor,
          decoration: BoxDecoration(
            color: ColorConstnats.backgroundColor,
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          child: Center(
            child: Text(
              "Save",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConstnats.primarywhite,
                fontSize: screenWidth * fontSizeFactor,
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
