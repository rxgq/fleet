import 'package:fleet/kanban/models/task_model.dart';

final class TaskColumnModel {
  final int id;
  final String title;
  final List<TaskModel> tasks = [];
  int position;
    
  TaskColumnModel({
    required this.id,
    required this.title,
    required this.position
  });

  static TaskColumnModel fromMap(Map<String, dynamic> map) {
    return TaskColumnModel(
      title: map["title"],
      id: map["id"],
      position: map["task_position"]
    );
  }
}