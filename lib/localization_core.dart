import 'dart:async';

import 'default_json_localization_decoder.dart';
import 'lang_registry.dart';
import 'localization_decoder.dart';
import 'localization_logger.dart';
import 'localization_source.dart';
import 'value_localization_exception.dart';

class ValueLocalizationCore {
  ValueLocalizationCore({
    required LocalizationSource source,
    LocalizationDecoder? decoder,
    LocalizationLogger? logger,
    LangRegistry? langRegistry,
  })  : _source = source,
        _decoder = decoder ?? const DefaultJsonLocalizationDecoder(),
        _logger = logger ?? const NoopLocalizationLogger(),
        _langRegistry = langRegistry ?? LangRegistry();

  final LocalizationSource _source;
  final LocalizationDecoder _decoder;
  final LocalizationLogger _logger;
  final LangRegistry _langRegistry;
  final StreamController<String> _langCodeController =
      StreamController<String>.broadcast();
  final Map<String, Map<String, String>> _cache =
      <String, Map<String, String>>{};

  Future<void> _operationChain = Future<void>.value();
  String? _currentLangCode;
  bool _isInitialized = false;
  bool _isDisposed = false;

  bool get isInitialized => _isInitialized;

  String get currentLangCode {
    _ensureInitialized();
    return _currentLangCode!;
  }

  Stream<String> get langCodeStream => _langCodeController.stream;

  Future<void> init({required String langCode}) {
    return _enqueue(() async {
      if (_isInitialized) {
        return;
      }
      await _activateLanguage(_normalizeLangCode(langCode));
    });
  }

  Future<void> set(String langCode) {
    return _enqueue(() async {
      _ensureInitialized();
      final nextLangCode = _normalizeLangCode(langCode);
      if (nextLangCode == _currentLangCode) {
        return;
      }
      await _activateLanguage(nextLangCode);
    });
  }

  String get(String key, {Map<String, dynamic>? params}) {
    _ensureInitialized();

    final translations = _cache[_currentLangCode];
    if (translations == null) {
      throw ValueLocalizationException.notInitialized();
    }

    final template = translations[key];
    if (template == null) {
      _logger.debug('Missing translation for key: $key');
      return key;
    }

    return _interpolate(template, params: params);
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    _langCodeController.close();
  }

  Future<void> _activateLanguage(String langCode) async {
    final translations = await _getOrLoadTranslations(langCode);
    _cache[langCode] = translations;
    _currentLangCode = langCode;
    _isInitialized = true;

    if (!_isDisposed) {
      _langCodeController.add(langCode);
    }
  }

  Future<Map<String, String>> _getOrLoadTranslations(String langCode) async {
    final cached = _cache[langCode];
    if (cached != null) {
      _logger.debug('Hit localization cache for langCode: $langCode');
      return cached;
    }

    final resolvedPath = _langRegistry.resolvePath(langCode);
    _logger.debug('Loading translation file: $resolvedPath');

    try {
      final rawContent = await _source.loadString(
        langCode: langCode,
        resolvedPath: resolvedPath,
      );
      final decoded = await _decoder.decode(rawContent);
      return Map.unmodifiable(decoded);
    } on ValueLocalizationException {
      rethrow;
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to load translation file for langCode: $langCode',
        error: error,
        stackTrace: stackTrace,
      );
      throw ValueLocalizationException.translationLoadFailed(
        langCode: langCode,
        resolvedPath: resolvedPath,
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<T> _enqueue<T>(Future<T> Function() action) {
    final completer = Completer<T>();

    _operationChain = _operationChain
        .catchError((Object _, StackTrace __) {})
        .then<void>((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });

    return completer.future;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw ValueLocalizationException.notInitialized();
    }
  }

  static String _normalizeLangCode(String langCode) {
    return langCode.trim().toLowerCase();
  }

  static String _interpolate(
    String template, {
    Map<String, dynamic>? params,
  }) {
    if (params == null || params.isEmpty) {
      return template;
    }

    var result = template;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value?.toString() ?? '');
    });
    return result;
  }
}