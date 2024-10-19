class TaskModel {
  final int id;
  final String title;
  final int columnId;
  final String description;
  final int position;

  TaskModel({
    required this.id,
    required this.title,
    required this.columnId,
    required this.description,
    required this.position
  });

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"],
      title: map["title"],
      columnId: map["status"],
      description: map["description"],
      position: map["position"]
    );
  }
}