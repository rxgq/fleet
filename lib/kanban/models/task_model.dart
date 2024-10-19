class TaskModel {
  final int id;
  final String title;
  final String status;
  final String description;
  final int position;

  TaskModel({
    required this.id,
    required this.title,
    required this.status,
    required this.description,
    required this.position
  });

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"],
      title: map["title"],
      status: map["status"],
      description: map["description"],
      position: map["position"]
    );
  }
}