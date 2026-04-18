import 'dart:convert';

import 'value_localization_exception.dart';

Map<String, String> decodeJsonTranslationContent(String rawContent) {
  final decoded = jsonDecode(rawContent);
  if (decoded is! Map) {
    throw ValueLocalizationException.invalidTranslationFormat(
      'Translation file root must be a JSON object.',
    );
  }

  final result = <String, String>{};
  decoded.forEach((key, value) {
    result[key.toString()] = value?.toString() ?? '';
  });
  return Map.unmodifiable(result);
}