import 'package:fleet/kanban/models/task_model.dart';

class TaskColumnModel {
  final int id;
  final String title;
  final List<TaskModel> tasks = [];

  TaskColumnModel({
    required this.id,
    required this.title
  });

  static TaskColumnModel fromMap(Map<String, dynamic> map) {
    return TaskColumnModel(
      title: map["title"],
      id: map["id"],
    );
  }
}