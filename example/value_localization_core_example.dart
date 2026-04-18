import 'package:value_localization_core/value_localization_core.dart';

void main() async {
  final core = ValueLocalizationCore(
    source: _InMemoryLocalizationSource(
      {
        'langFiles/app_zh.json': '{"hello":"你好，{name}"}',
        'langFiles/app_en.json': '{"hello":"Hello, {name}"}',
      },
    ),
  );

  await core.init(langCode: 'zh');
  print(core.get('hello', params: {'name': 'Value'}));

  await core.set('en');
  print(core.get('hello', params: {'name': 'Value'}));
}

class _InMemoryLocalizationSource implements LocalizationSource {
  _InMemoryLocalizationSource(this._files);

  final Map<String, String> _files;

  @override
  Future<String> loadString({
    required String langCode,
    required String resolvedPath,
  }) async {
    final content = _files[resolvedPath];
    if (content == null) {
      throw Exception('Missing file: $resolvedPath');
    }
    return content;
  }
}