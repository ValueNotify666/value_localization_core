import 'dart:isolate';

import 'json_translation_parser.dart';
import 'localization_decoder.dart';

class IsolateJsonLocalizationDecoder implements LocalizationDecoder {
  const IsolateJsonLocalizationDecoder();

  @override
  Future<Map<String, String>> decode(String rawContent) {
    return Isolate.run(() => decodeJsonTranslationContent(rawContent));
  }
}