final class TaskProjectModel {
  final int projectId;
  final String title;

  TaskProjectModel({
    required this.projectId,
    required this.title
  });

  static TaskProjectModel fromMap(Map<String, dynamic> map) {
    return TaskProjectModel(
      projectId: map["project_id"],
      title: map["project"]
    );
  }
}