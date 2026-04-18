abstract interface class LocalizationDecoder {
  Future<Map<String, String>> decode(String rawContent);
}