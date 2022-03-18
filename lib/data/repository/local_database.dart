import 'dart:convert';

import 'package:almaviva_app/domain/repositories/local_database_interface.dart';
import 'package:hive/hive.dart';

class LocalDatabaseService extends LocalDatabaseInterface {
  @override
  bool putValue(String box, String key, dynamic value) {
    var settingsBox = Hive.box(box);
    try {
      String saveString = json.encode(value);
      print("$key - $saveString");
      settingsBox.put(key, saveString);
      return true;
    } catch (e) {
      print("An Exception has ocurred: $e");
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getValueFromKey(String box, String key) async {
    var settingsBox = Hive.box(box);
    try {
      String settingModel = settingsBox.get(key);
      Map<String, dynamic> jsonDecode = json.decode(settingModel);
      return jsonDecode;
    } catch (e) {
      print("An Exception has ocurred: $e");
      return {};
    }
  }
}
