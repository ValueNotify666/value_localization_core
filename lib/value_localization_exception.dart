class ValueLocalizationException implements Exception {
  const ValueLocalizationException({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  factory ValueLocalizationException.notInitialized() {
    return const ValueLocalizationException(
      code: 'not_initialized',
      message:
          'ValueLocalizationCore has not been initialized. Call init(langCode: ...) first.',
    );
  }

  factory ValueLocalizationException.translationLoadFailed({
    required String langCode,
    required String resolvedPath,
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return ValueLocalizationException(
      code: 'translation_load_failed',
      message:
          "[value_localization_core]-ERR-Cannot load translation file for langCode '$langCode': '$resolvedPath'",
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  factory ValueLocalizationException.invalidTranslationFormat(String message) {
    return ValueLocalizationException(
      code: 'invalid_translation_format',
      message: message,
    );
  }

  @override
  String toString() {
    if (code == null || code!.isEmpty) {
      return 'ValueLocalizationException: $message';
    }
    return 'ValueLocalizationException($code): $message';
  }
}