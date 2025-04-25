import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/image_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomepageController with ChangeNotifier {
  static late Box myBox;
  static late Box completedBox;
  static List<bool> donelist = [];
  static List<bool> backlist = [];
  static List notelistKeys = [];
  static List completedKeys = [];

  static Future<void> initialize() async {
    myBox = await Hive.openBox('MyBox');
    completedBox = await Hive.openBox("completedBox");
    notelistKeys = myBox.keys.toList();
    completedKeys = completedBox.keys.toList();

    donelist = List<bool>.filled(notelistKeys.length, false, growable: true);
    backlist = List<bool>.filled(completedKeys.length, true, growable: false);
  }

  List imageList = [
    ImageConstants.event,
    ImageConstants.goal,
    ImageConstants.task,
  ];

  Future<void> addNote(
      {required String title,
      required String date,
      required String time,
      required String reason,
      int imageIndex = 0}) async {
    await myBox.add({
      "title": title,
      "date": date,
      "time": time,
      "reason": reason,
      "imageIndex": imageIndex,
    });
    notelistKeys = myBox.keys.toList();
    donelist = List<bool>.filled(notelistKeys.length, false, growable: true);
    notifyListeners();
  }

  Future<void> deleteListnote(var key) async {
    await myBox.delete(key);
    notelistKeys = myBox.keys.toList();
    donelist = List<bool>.filled(notelistKeys.length, false, growable: true);
    notifyListeners();
  }

  Future<void> deleteListcomplete(var key) async {
    await completedBox.delete(key);
    completedKeys = completedBox.keys.toList();
    notifyListeners();
  }

  Future<void> editNoteList({
    required String title,
    required String date,
    required String time,
    required String reason,
    required var key,
    int imageIndex = 0,
  }) async {
    if (myBox.containsKey(key)) {
      await myBox.put(key, {
        "title": title,
        "date": date,
        "time": time,
        "reason": reason,
        "imageIndex": imageIndex,
      });
      getinikey();
    } else {
      log("Key does not exist-----");
    }
  }

  getinikey() {
    notelistKeys = myBox.keys.toList();
    completedKeys = completedBox.keys.toList();
    backlist = List<bool>.filled(completedKeys.length, true, growable: false);
    donelist = List<bool>.filled(notelistKeys.length, false, growable: true);
    notifyListeners();
  }

  removelist(int index, var value, var key) async {
    donelist[index] = value;
    log("donelist index turns true at--${donelist.indexOf(true)}");

    if (value == true) {
      var data = myBox.get(key);
      if (data != null) {
        await completedBox.put(key, data);
        completedKeys.add(key);
        // log("completedbox----$data");
        await myBox.delete(key);
        notelistKeys.remove(key);
        // log("completedkey list--$completedKeys");
        getinikey();
      } else {
        log("Data with key ----- $key ");
      }
    }

    notifyListeners();
  }

  returnlist(int index, var value, var key) async {
    backlist[index] = value;
    log("donelist index turns true at--${backlist.indexOf(false)}");
    log("backlist index turns true at--${backlist[index]}");
    log("value--${value}");

    if (value == false) {
      var data = completedBox.get(key);
      log("todo list----$data");
      if (data != null) {
        await myBox.put(key, data);
        notelistKeys.add(key);

        await completedBox.delete(key);
        completedKeys.remove(key);
        // log("completedkey list--$notelistKeys");
        getinikey();
      } else {
        log("Data with key ----- $key ");
      }
    }

    notifyListeners();
  }

  // Future<void> deleteAllNotes() async {
  //   await myBox.clear();
  //   await completedBox.clear();
  //   notelistKeys = [];
  //   completedKeys = [];
  //   donelist = [];
  //   notifyListeners();
  // }
}
