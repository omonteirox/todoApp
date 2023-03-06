import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task {
  String taskName;
  DateTime date;
  Task({
    required this.taskName,
    required this.date,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskName': taskName,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskName: map['taskName'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
