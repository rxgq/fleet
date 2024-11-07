import 'package:bcrypt/bcrypt.dart';
import 'package:fleet/kanban/services/database/fleet_context.dart';
import 'package:fleet/kanban/services/logger/logger.dart';

final class AuthService {
  final _db = FleetContext();
  final _logger = Logger();

  Future<bool> login(String username, String password) async {
    try {
      await _db.open();

      final result = await _db.conn!.execute(
        "select * from users where username = '$username'"
      );

      if (result.isEmpty) {
        _logger.LogInfo("User $username not found.");
        return false;
      }

      var user = result.first;
      var storedHash = user[2].toString();

      var isOk = verifyPwd(password, storedHash);
      
      _logger.LogInfo(isOk ? "Logged in." : "Failed to login.");
      return isOk;

    } catch (ex) {
      _logger.LogError("Error logging in: $ex");
      return false;
    }
  }

  String hashPwd(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  bool verifyPwd(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }
}