final class TaskModel {
  final int id;
  final String title;
  final String description;
  final int position;
  int columnId;
  int? projectId;
  String status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    required this.columnId,
    required this.projectId,
    this.status = ""
  });

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"],
      title: map["title"],
      columnId: map["column_id"],
      projectId: map["project_id"],
      description: map["description"],
      position: map["position"],
    );
  }
}