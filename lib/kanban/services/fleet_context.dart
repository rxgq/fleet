
import 'dart:io';

import 'package:postgres/postgres.dart';

import 'logger.dart';

final class FleetContext {
  final _logger = Logger();
  Connection? conn;
  
  Future<void> open() async {
    try {
      if (conn?.isOpen == true) {
        _logger.LogInfo("Open connection reused.");
        return;
      }

      final pass = Platform.environment['db_pass'];

      conn = await Connection.open(
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

      _logger.LogInfo("Opened connection.");
    } catch (ex) {
      _logger.LogError("Error opening connection: $ex");
      conn = null;
    }
  }

  Future<void> close() async {
    try {
      if (conn != null && conn!.isOpen) {
        await conn!.close();
        _logger.LogInfo("Closed connection.");
      }
    } catch (ex) {
      _logger.LogError("Error closing connection: $ex");
    } finally {
      conn = null;
    }
  }
}