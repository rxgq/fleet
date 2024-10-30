final class Logger {
  Future<void> LogInfo(final String message) async {
    print("Logged Info: $message");
  }

  Future<void> LogError(final String error) async {
    print("Logged Error: $error");
  }
}