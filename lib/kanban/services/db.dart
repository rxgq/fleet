import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';
import 'package:postgres/postgres.dart';
import 'dart:io';

class DatabaseService {
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
}