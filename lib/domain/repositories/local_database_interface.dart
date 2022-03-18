abstract class LocalDatabaseInterface {
  Future<Map<String, dynamic>> getValueFromKey(String box, String key);
  bool putValue(String box, String key, dynamic value);
}
