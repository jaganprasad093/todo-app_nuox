import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTaskHelper {
  static Future<void> selectDate(
      BuildContext context,
      TextEditingController dateController,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      onDateSelected(picked);
    }
  }

  static Future<void> selectTime(
      BuildContext context, TextEditingController timeController) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      timeController.text =
          "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  static bool validateForm(
      GlobalKey<FormState> formKey,
      TextEditingController titleController,
      TextEditingController dateController,
      TextEditingController timeController,
      TextEditingController noteController) {
    return formKey.currentState?.validate() ?? false;
  }
}
