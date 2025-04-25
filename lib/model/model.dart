import 'dart:convert';

class taskmodel {
  String? title;

  String? date;

  String? time;

  String? notes;
  String? reason;
  int? imageIndex;
  taskmodel({
    this.title,
    this.date,
    this.notes,
    this.time,
    this.imageIndex,
    this.reason,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date': date,
      'time': time,
      'notes': notes,
      'reason': reason,
      'imageIndex': imageIndex,
    };
  }

  factory taskmodel.fromMap(Map<String, dynamic> map) {
    return taskmodel(
      title: map['title'] != null ? map['title'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      time: map['time'] != null ? map['time'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
      imageIndex: map['imageIndex'] != null ? map['imageIndex'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory taskmodel.fromJson(String source) =>
      taskmodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
