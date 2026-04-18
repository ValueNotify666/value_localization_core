import 'json_translation_parser.dart';
import 'localization_decoder.dart';

class DefaultJsonLocalizationDecoder implements LocalizationDecoder {
  const DefaultJsonLocalizationDecoder();

  @override
  Future<Map<String, String>> decode(String rawContent) async {
    return decodeJsonTranslationContent(rawContent);
  }
}