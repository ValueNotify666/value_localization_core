abstract interface class LocalizationSource {
  Future<String> loadString({
    required String langCode,
    required String resolvedPath,
  });
}