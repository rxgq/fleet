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

  Future getTasks() async {
    await _open();

    final tasks = await _conn!.execute(
      "select * from tasks"
    );
    
    for (var task in tasks) {
      print(task);
    }

  }
}