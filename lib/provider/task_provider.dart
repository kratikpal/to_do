import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/constants/urls.dart';
import 'package:to_do/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];
  bool isLoading = false;
  final List<TaskModel> _allTasks = [];

  Future<void> getTaskFromAPI() async {
    final dio = Dio();
    isLoading = true;
    notifyListeners();
    try {
      final response = await dio.get(getTaskUrl);

      if (response.statusCode == 200) {
        final List<dynamic> taskListJson = response.data;
        tasks = taskListJson
            .map((taskJson) => TaskModel.fromJson(taskJson))
            .toList();
        _allTasks.addAll(tasks);
        await saveTasks();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? taskListString = prefs.getString('tasks');
    List<TaskModel> data = [];
    if (taskListString != null) {
      // If tasks exist in storage, decode and set them
      final List<dynamic> taskListJson = jsonDecode(taskListString);
      data =
          taskListJson.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
    }
    _allTasks.addAll(data);
    tasks.addAll(data);
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> taskListJson =
        tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', jsonEncode(taskListJson));
  }

  List<TaskModel> get getTasks {
    return tasks;
  }

  // Add a task
  Future<void> addTask(TaskModel task) async {
    tasks.add(task);
    _allTasks.add(task);
    await saveTasks();
    notifyListeners();
  }

  // Remove a task
  Future<void> removeTask(TaskModel task) async {
    tasks.remove(task);
    _allTasks.remove(task);
    await saveTasks();
    notifyListeners();
  }

  // Update a task's completion status
  Future<void> updateTask(bool isDone, TaskModel task) async {
    task.isDone = isDone;
    await saveTasks();
    notifyListeners();
  }

  // Search function that filters tasks based on query
  void searchTask(String query) {
    if (query.isEmpty) {
      tasks = List.from(_allTasks);
    } else {
      tasks = _allTasks.where((task) {
        return task.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
