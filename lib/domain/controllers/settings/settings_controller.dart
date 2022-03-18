import 'package:almaviva_app/domain/repositories/local_database_interface.dart';
import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';

import 'package:get/get.dart';

class SettingsController extends GetxController {
  final DatawedgeServiceInterface datawedgeServiceInterface;
  final LocalDatabaseInterface databaseInterface;
  var settings = {}.obs;

  SettingsController({required this.datawedgeServiceInterface, required this.databaseInterface});
  @override
  void onInit() {
    super.onInit();
  }

  void executeSettingModify() {
    if (verifySettings()) {
      databaseInterface.putValue("settings", "settings", settings);
      datawedgeServiceInterface.modifySettings(
          numberOfCodes: int.parse(settings["Cantidad"]),
          timer: int.parse(settings["Temporizador"]),
          reportInstantly: settings["Reporte"],
          beamWidth: 0);
    }
  }

  void printVersion() {
    datawedgeServiceInterface.printVersion();
  }

  bool verifySettings() {
    if (settings.keys.length < 4) return false;
    if (settings.values.length < 4) return false;
    return true;
  }

  int setValueOnSettings(String key, dynamic value) {
    print("$key - $value");

    if (!key.contains("Serial")) {
      settings[key] = value;
      return 0;
    }
    if (!settings.keys.contains("Serials")) settings["Serials"] = {};
    settings["Serials"][key] = value;
    print("${settings["Serials"]}");
    return 0;
  }

  void printSettings() async {
    var settingsFromBox = await databaseInterface.getValueFromKey("settings", "settings");
    for (var key in settingsFromBox.keys) {
      if (key.contains("Serial")) {
        print("Serials :  ${settingsFromBox["Serials"]}");
      } else {
        print("$key : ${settingsFromBox[key]}");
      }
    }
  }

  @override
  void onClose() {
    datawedgeServiceInterface.closeStreamController();
    super.onClose();
  }
}
