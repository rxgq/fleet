import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';
import 'package:postgres/postgres.dart';
import 'dart:io';

class DatabaseService {
  final _board = BoardController();
  Connection? _conn;

  Future<void> _open() async {
    try {
      final pass = Platform.environment['db_pass'];

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
    }
  }

  Future<List<TaskColumnModel>> getColumns() async {
    await _open();

    final columnRows = await _conn!.execute("select * from columns");
    final columns = columnRows.map((col) => TaskColumnModel.fromMap({
      "id": col[0],
      "title": col[1]
    })).toList();

    return columns;
  }

  Future<List<TaskModel>> getTasks() async {
    await _open();

    final taskRows = await _conn!.execute("select * from tasks");
    final tasks = taskRows.map((row) => TaskModel.fromMap({
      "id": row[0],
      "title": row[1],
      "status": row[2],
      "description": row[3],
      "position": row[4],
    })).toList();

    return tasks;
  }

  Future refreshBoard() async {
    final columns = await getColumns();
    final tasks = await getTasks();

    _board.setColumns(columns);
    _board.addTasks(tasks);
  }

  Future<bool> updateStatus(TaskModel task, TaskColumnModel column) async {
    await _open();

    final result = await _conn!.execute(
      "update tasks set columnId = ${column.id} where id = ${task.id}",
    );

    await refreshBoard();
    return result.affectedRows != 0;
  }

  Future<bool> updateDescription(TaskModel task, String description) async {
    await _open();

    final result = await _conn!.execute(
      "update tasks set description = '$description' where id = ${task.id}",
    );

    await refreshBoard();
    return result.affectedRows != 0;
  }

  Future<bool> createTask(String title, TaskColumnModel column) async {
    await _open();

    final result = await _conn!.execute(
      "insert into tasks (title, columnId, description, position) values ('$title', ${column.id}, '', 0);"
    );

    await refreshBoard();
    return result.affectedRows != 0;
  }

  Future<bool> deleteTask(TaskModel task) async {
    await _open();

    final result = await _conn!.execute(
      "delete from tasks where id = ${task.id}"
    );

    await refreshBoard();
    return result.affectedRows != 0;
  }

    Future<bool> createColumn(String title) async {
    await _open();

    final result = await _conn!.execute(
      "insert into columns (title) values ('$title');"
    );

    await refreshBoard();
    return result.affectedRows != 0;
  }
}