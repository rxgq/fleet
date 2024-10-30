final class Logger {
  static const String _infoColor = '\x1B[34m';
  static const String _eventColor = '\x1B[32m';
  static const String _errorColor = '\x1B[31m';
  static const String _resetColor = '\x1B[0m';

  Future<void> LogInfo(final String message) async {
    print("${_infoColor}Info: $message$_resetColor");
  }

  Future<void> LogEvent(final String event) async {
    print("${_eventColor}Event: $event$_resetColor");
  }

  Future<void> LogError(final String error) async {
    print("${_errorColor}Error: $error$_resetColor");
  }
}
