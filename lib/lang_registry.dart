class LangRegistry {
  LangRegistry({Map<String, String>? paths}) : _paths = {...?paths};

  final Map<String, String> _paths;

  void register(String langCode, {String? resolvedPath}) {
    _paths[_normalizeLangCode(langCode)] =
        resolvedPath ?? defaultPathFor(langCode);
  }

  void registerAll(Iterable<String> langCodes) {
    for (final langCode in langCodes) {
      register(langCode);
    }
  }

  void registerPath(String langCode, String resolvedPath) {
    _paths[_normalizeLangCode(langCode)] = resolvedPath;
  }

  bool contains(String langCode) {
    return _paths.containsKey(_normalizeLangCode(langCode));
  }

  String resolvePath(String langCode) {
    final normalizedLangCode = _normalizeLangCode(langCode);
    return _paths[normalizedLangCode] ?? defaultPathFor(normalizedLangCode);
  }

  Map<String, String> snapshot() {
    return Map.unmodifiable(_paths);
  }

  static String defaultPathFor(String langCode) {
    return 'langFiles/app_${_normalizeLangCode(langCode)}.json';
  }

  static String _normalizeLangCode(String langCode) {
    return langCode.trim().toLowerCase();
  }
}