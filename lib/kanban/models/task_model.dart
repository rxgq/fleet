import 'package:fleet/kanban/models/task_project_model.dart';

final class TaskModel {
  final int id;
  final String title;
  final String description;
  final int position;
  final int priority;

  int columnId;
  String status;

  final TaskProjectModel? project;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    required this.priority,
    required this.columnId,
    this.status = "",
    this.project,
  });

  static TaskModel fromMap(Map<String, dynamic> map) {
    final project = TaskProjectModel(
      projectId: map["project_id"] ?? -1,
      title: map["project"].toString()
    );


    return TaskModel(
      id: map["id"],
      title: map["title"],
      columnId: map["column_id"],
      description: map["description"],
      position: map["position"],
      priority: map["priority"],
      project: (map["project"] == null || map["project_id"] == null) ? null : project,
    );
  }
}