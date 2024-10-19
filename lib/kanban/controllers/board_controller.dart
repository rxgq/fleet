import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';

class BoardController {
  BoardController._internal();

  static final BoardController _instance = BoardController._internal();
  factory BoardController() {
    return _instance;
  }

  List<TaskColumnModel> columns = [];

  void setColumns(List<TaskColumnModel> newColumns) {
    columns = newColumns;
  }

  void addTasks(List<TaskModel> tasks) {
    for (final task in tasks) {
      for (final col in columns) {
        if (col.id != task.columnId) continue;
        col.tasks.add(task);
      }
    }
  }
}