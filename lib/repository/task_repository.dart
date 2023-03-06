// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

const taskListKey = 'task_list';

class TaskRepository {
  late SharedPreferences sharedPreferences;
  void saveTodoList(List<Task> tasks) {
    final String jsonString = json.encode(tasks);
    sharedPreferences.setString(taskListKey, jsonString);
  }

  Future<List<Task>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(taskListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Task.fromJson(e)).toList();
  }
}
