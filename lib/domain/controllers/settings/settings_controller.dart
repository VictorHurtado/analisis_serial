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
    getSettingsOnDB();
  }

  void getSettingsOnDB() async {
    settings.value = await databaseInterface.getValueFromKey("settings", "settings");
  }

  void executeSettingModify() {
    if (verifySettings()) {
      // printSettings();

      databaseInterface.putValue("settings", "settings", settings);
      datawedgeServiceInterface.modifySettings(
          numberOfCodes: int.parse(settings["Cantidad"]),
          timer: int.parse(settings["Temporizador"]),
          reportInstantly: settings["Reporte"],
          aimType: int.parse(settings["Tipo"]),
          beamWidth: 0);
    }
  }

  void printVersion() {
    datawedgeServiceInterface.printVersion();
  }

  bool verifySettings() {
    if (settings.keys.length < 3) return false;
    if (settings.values.length < 3) return false;
    return true;
  }

  int setValueOnSettings(String key, dynamic value) {
    if (!key.contains("Serial")) {
      settings[key] = value;
      return 0;
    }

    if (!settings.keys.contains("Serials")) settings["Serials"] = {};
    if (value == "No aplica") {
      settings["Serials"].remove(key);
      return 0;
    }
    settings["Serials"][key] = value;

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
