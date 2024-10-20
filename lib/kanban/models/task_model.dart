class TaskModel {
  final int id;
  final String title;
  final String description;
  final int position;
  int columnId;
  String status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    required this.columnId,
    required this.status
  });

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"],
      title: map["title"],
      columnId: map["status"],
      description: map["description"],
      position: map["position"],
      status: ""
    );
  }
}