import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/services/logger.dart';

import '../models/task_project_model.dart';
import 'fleet_context.dart';

final class DatabaseService {
  final _board = BoardController();
  final _db = FleetContext();

  final _logger = Logger();

  // Future<T> execute<T>(Future<T> Function() operation, String message) async {
  //   await _db.open();
    
  //   try {
  //     return await operation();
  //   } catch (ex) {
  //     _logger.LogError("$message: $ex");
  //     rethrow;
  //   } finally {
  //     await _db.close();
  //   }
  // }

  Future<List<TaskColumnModel>> getColumns() async {
    try {
      await _db.open();

      final columnRows = await _db.conn!.execute("select * from task_columns");
      final columns = columnRows.map((col) => TaskColumnModel.fromMap({
        "id": col[0],
        "title": col[1],
        "task_position": col[2]
      })).toList();
      
      _logger.LogInfo("Got '${columns.length}' column(s).");
      return columns;
    } catch (ex) {
      _logger.LogError("Error getting columns: $ex");
      return [];
    }
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      await _db.open();

      var projects = await getProjects();

      final taskRows = await _db.conn!.execute("select * from tasks");
      final tasks = taskRows.map((row) {

        final projectId = row[5]?.toString();
        final project = projects.where((p) => p.projectId == int.parse(projectId ?? "0")).firstOrNull;

        return TaskModel.fromMap({
          "id": row[0],
          "column_id": row[1],
          "title": row[2],
          "description": row[3],
          "position": row[4],
          "priority": row[6],
          "project_id": project?.projectId,
          "project": project?.title,
        });
      }).toList();

      _logger.LogInfo("Got '${tasks.length}' task(s).");
      return tasks;
    } catch (ex) {
      _logger.LogError("Error getting tasks: $ex");
      return [];
    }
  }
  
  Future<List<TaskProjectModel>> getProjects() async {
    try {
      await _db.open();

      final projectRows = await _db.conn!.execute("select * from projects");
      final projects = projectRows.map((row) => TaskProjectModel.fromMap({
        "project_id": row[0],
        "project": row[1]
      })).toList();

      _logger.LogInfo("Got '${projects.length}' projects(s).");
      return projects;

    } catch (ex) {
      _logger.LogError("Error getting projects: $ex");
      return [];
    }
  }

  Future<void> refreshBoard() async {
    final columns = await getColumns();
    final projects = await getProjects();
    final tasks = await getTasks();

    _board.setColumns(columns);
    _board.setProjects(projects);
    _board.addTasks(tasks);

    await _db.close();
    _logger.LogInfo("Refreshed board.\n");
  }

  Future<bool> updateTaskStatus(final TaskModel task, final TaskColumnModel column) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "update tasks set column_id = ${column.id} where task_id = ${task.id}",
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Updated task '${task.title}' status to '${column.title}'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error updating task status: $ex");
      return false;
    }
  }

  Future<bool> updateTaskDescription(final TaskModel task, final String description) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "update tasks set description = '$description' where task_id = ${task.id}",
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Updated task '${task.title}' description.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error updating task description: $ex");
      return false;
    }
  }
  
  Future<bool> updateTaskProject(final TaskModel task, final TaskProjectModel project) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "update tasks set project_id = '${project.projectId}' where task_id = ${task.id}",
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Updated task '${task.title}' project to '${project.title}'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error updating task project: $ex");
      return false;
    }
  }

  Future<bool> updateTaskPriority(final TaskModel task, final int priority) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "update tasks set priority  = '$priority' where task_id = ${task.id}",
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Updated task '${task.title}' priority to '$priority'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error updating task project: $ex");
      return false;
    }
  }

  Future<bool> createTask(final String title, final int column) async {
    try {
      await _db.open();

      int? project = _board.projects
        .where((x) => x.title == "general").firstOrNull?.projectId;

      final result = await _db.conn!.execute(
        "insert into tasks (title, column_id, description, task_position, project_id) values ('$title', '$column', '', 0, $project);"
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Created task '$title'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error creating task: $ex");
      return false;
    }
  }

  Future<bool> deleteTask(final TaskModel task) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "delete from tasks where task_id = ${task.id}"
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Deleted task '${task.title}'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error deleting task: $ex");
      return false;
    }
  }

  Future<bool> createColumn(final String title) async {
    try {
      await _db.open();

      var columns = await getColumns();
      int maxPos = columns.isEmpty ? 0 : columns
        .map((col) => col.position).reduce((a, b) => a > b ? a : b);

      final result = await _db.conn!.execute(
        "insert into task_columns (title, column_position) values ('$title', ${maxPos + 1});"
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Created column '$title'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error creating column: $ex");
      return false;
    }
  }

  Future<bool> deleteColumn(final TaskColumnModel column) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "delete from task_columns where column_id = ${column.id}"
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Deleted column '${column.title}'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error deleting column: $ex");
      return false;
    }
  }

  Future<bool> updateColumnTitle(final TaskColumnModel column, final String title) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "update task_columns set title = '$title' where column_id = ${column.id}"
      );

      await refreshBoard();
      await _db.close();

      _logger.LogInfo("Updated column '${column.title}' to '$title'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error updating column title: $ex");
      return false;
    }
  }

Future<bool> updateColumnPosition(final TaskColumnModel column, final int newPosition) async {
  try {
    await _db.open();

    int currentPosition = column.position;

    if (currentPosition == newPosition) {
      await _db.close();
      return true;
    }

    if (newPosition < currentPosition) {
      await _db.conn!.execute(
        "update task_columns set column_position = column_position + 1 "
        "where column_position >= $newPosition and column_position < $currentPosition"
      );
    } else {
      await _db.conn!.execute(
        "update task_columns set column_position = column_position - 1 "
        "where column_position <= $newPosition and column_position > $currentPosition"
      );
    }

    final result = await _db.conn!.execute(
      "update task_columns set column_position = $newPosition where column_id = ${column.id}"
    );

    await refreshBoard();
    await _db.close();

    _logger.LogInfo("Moved column '${column.title}' to position '$newPosition'.");
    return result.affectedRows != 0;
  } catch (ex) {
    _logger.LogError("Error updating column position: $ex");
    return false;
  }
}


  Future<bool> createProject(final String title) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "insert into projects (title) values ('$title')"
      );

      await _db.close();

      _logger.LogInfo("Created project '$title'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error creating project: $ex");
      return false;
    }
  }

  Future<bool> deleteProject(final TaskProjectModel project) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "delete from projects where project_id = '${project.projectId}'"
      );

      await _db.close();

      _logger.LogInfo("Deleted project '${project.title}'.");
      return result.affectedRows != 0;
    } catch (ex) {
      _logger.LogError("Error deleting project: $ex");
      return false;
    }
  }
}