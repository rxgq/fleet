import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/services/logger.dart';
import 'package:postgres/postgres.dart';
import 'dart:io';

final class DatabaseService {
  final _board = BoardController();
  Connection? _conn;

  final _logger = Logger();

  Future<void> _open() async {
    try {
      final pass = Platform.environment['db_pass'];
      if (_conn?.isOpen == true) return;

      _conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'postgres',
          password: pass,
        ), 
        settings: const ConnectionSettings(
          sslMode: SslMode.disable
        )
      );

    } catch (ex) {
      print(ex);
      _conn = null;
    }
  }

  Future<void> _close() async {
    try {
      if (_conn != null && _conn!.isOpen) {
        await _conn!.close();
      }
    } catch (ex) {
      print(ex);
    } finally {
      _conn = null;
    }
  }

  Future<List<TaskColumnModel>> getColumns() async {
    try {
      await _open();

      final columnRows = await _conn!.execute("select * from task_columns");
      final columns = columnRows.map((col) => TaskColumnModel.fromMap({
        "id": col[0],
        "title": col[1],
        "task_position": col[2]
      })).toList();

      return columns;
    } catch (ex) {
      print("Exception in getColumns: $ex");
      return [];
    }
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      await _open();

      final taskRows = await _conn!.execute("select * from tasks");

      final tasks = taskRows.map((row) => TaskModel.fromMap({
        "id": row[0],
        "column_id": row[1],
        "title": row[2],
        "description": row[3],
        "position": row[4],
      })).toList();

      await _close();
      return tasks;
    } catch (ex) {
      print("Exception in getTasks: $ex");
      return [];
    }
  }

  Future<void> refreshBoard() async {
    final columns = await getColumns();
    final tasks = await getTasks();

    _board.setColumns(columns);
    _board.addTasks(tasks);
  }

  Future<bool> updateStatus(final TaskModel task, final TaskColumnModel column) async {
    try {
      await _open();

      final result = await _conn!.execute(
        "update tasks set column_id = ${column.id} where task_id = ${task.id}",
      );

      await refreshBoard();
      await _close();

      return result.affectedRows != 0;
    } catch (ex) {
      print("Exception in updateStatus: $ex");
      return false;
    }
  }

  Future<bool> updateDescription(final TaskModel task, final String description) async {
    try {
      await _open();

      final result = await _conn!.execute(
        "update tasks set description = '$description' where task_id = ${task.id}",
      );

      await refreshBoard();
      await _close();

      return result.affectedRows != 0;
    } catch (ex) {
      print("Exception in updateDescription: $ex");
      return false;
    }
  }

  Future<bool> createTask(final String title, final TaskColumnModel column) async {
    try {
      await _open();

      final result = await _conn!.execute(
        "insert into tasks (title, column_id, description, task_position) values ('$title', ${column.id}, '', 0);"
      );

      await refreshBoard();
      await _close();

      return result.affectedRows != 0;
    } catch (ex) {
      print("Exception in createTask: $ex");
      return false;
    }
  }

  Future<bool> deleteTask(final TaskModel task) async {
    try {
      await _open();

      final result = await _conn!.execute(
        "delete from tasks where task_id = ${task.id}"
      );

      await refreshBoard();
      await _close();

      return result.affectedRows != 0;
    } catch (ex) {
      print("Exception in deleteTask: $ex");
      return false;
    }
  }

  Future<bool> createColumn(final String title) async {
    try {
      await _open();

      var columns = await getColumns();
      int maxPos = columns.isEmpty ? 0 : columns
        .map((col) => col.position).reduce((a, b) => a > b ? a : b);

      final result = await _conn!.execute(
        "insert into task_columns (title, column_position) values ('$title', ${maxPos + 1});"
      );

      await refreshBoard();
      await _close();

      return result.affectedRows != 0;
    } catch (ex) {
      print("Exception in createColumn: $ex");
      return false;
    }
  }

  Future<bool> deleteColumn(final TaskColumnModel column) async {
    try {
      await _open();

      final result = await _conn!.execute(
        "delete from task_columns where column_id = ${column.id}"
      );

      await refreshBoard();
      await _close();

      return result.affectedRows != 0;
    } catch (ex) {
      print("Exception in deleteColumn: $ex");
      return false;
    }
  }

  Future<bool> updateColumnTitle(final TaskColumnModel column, final String title) async {
    try {
      await _open();

      final result = await _conn!.execute(
        "update task_columns set title = '$title' where column_id = ${column.id}"
      );

      await refreshBoard();
      await _close();

      return result.affectedRows != 0;
    } catch (ex) {
      print("Exception in updateColumnTitle: $ex");
      return false;
    }
  }
}