import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/models/task_project_model.dart';

class BoardController {
  BoardController._internal();

  static final BoardController _instance = BoardController._internal();
  factory BoardController() {
    return _instance;
  }

  List<TaskColumnModel> columns = [];
  List<TaskProjectModel> projects = [];

  TaskColumnModel? getColumn(String title) {
    return columns.where((x) => x.title.toLowerCase() == title.toLowerCase()).firstOrNull;
  }

  TaskProjectModel? getProject(String title) {
    return projects.where((x) => x.title.toLowerCase() == title.toLowerCase()).firstOrNull;
  }

  TaskModel? getTask(String title) {
    for (var column in columns) {
      var task = column.tasks.where((x) => x.title.toLowerCase() == title.toLowerCase()).firstOrNull;
      if (task != null) return task; 
    }

    return null;
  }

  void setColumns(final List<TaskColumnModel> newColumns) {
    newColumns.sort((a, b) => a.position.compareTo(b.position));
    columns = newColumns;
  }

  void setProjects(final List<TaskProjectModel> newProjects) {
    projects = newProjects;
  }

  void addTasks(final List<TaskModel> tasks) {
    for (final task in tasks) {
      for (final col in columns) {
        if (col.id != task.columnId) continue;

        task.status = col.title;
        col.tasks.add(task);
      }
    }

    for (var column in columns) {
      column.tasks.sort((a, b) => b.priority.compareTo(a.priority));
    }
  }
}