abstract interface class LocalizationLogger {
  void debug(String message);

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}

class NoopLocalizationLogger implements LocalizationLogger {
  const NoopLocalizationLogger();

  @override
  void debug(String message) {}

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {}
}