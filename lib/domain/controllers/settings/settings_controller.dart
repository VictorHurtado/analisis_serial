import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';

import 'package:get/get.dart';

class SettingsController extends GetxController {
  final DatawedgeServiceInterface datawedgeServiceInterface;
  var settings = {}.obs;

  SettingsController({required this.datawedgeServiceInterface});
  @override
  void onInit() {
    super.onInit();
  }

  void executeSettingModify() {
    printSettings();
    if (verifySettings()) {
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
    if (settings.keys.length < 3) return false;
    if (settings.values.length < 3) return false;
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

  void printSettings() {
    for (var key in settings.keys) {
      if (key.contains("Serial")) {
        print("Serials :  ${settings["Serials"]}");
      } else {
        print("$key : ${settings[key]}");
      }
    }
  }

  @override
  void onClose() {
    datawedgeServiceInterface.closeStreamController();
    super.onClose();
  }
}
