import 'package:almaviva_app/domain/repositories/local_database_interface.dart';
import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';

import 'package:get/get.dart';

class ScanController extends GetxController {
  final DatawedgeServiceInterface datawedgeServiceInterface;
  final LocalDatabaseInterface databaseInterface;
  var matrixOfCodes = {}.obs;

  ScanController({required this.datawedgeServiceInterface, required this.databaseInterface});
  @override
  void onInit() {
    createProfileForScanning();
    datawedgeServiceInterface.listenScanResult();
    datawedgeServiceInterface.eventOnDatawedge.listen((event) {
      print("evento: $event");
      matrixOfCodes.value = event;
      print(matrixOfCodes.values.length);
    });
    super.onInit();
  }

  void getSettingsOnDB() async {
    var settings = await databaseInterface.getValueFromKey("settings", "settings");
    if (settings.keys.isNotEmpty) {
      datawedgeServiceInterface.stablishMatrixOfCodes(settings["Serials"].length);
      print("Settings quantity: ${settings} ");
    }
  }

  void printVersion() {
    datawedgeServiceInterface.printVersion();
  }

  void createProfileForScanning() {
    datawedgeServiceInterface.createProfile("DataWedgeFlutterDemo");
  }

  void activeSesionScanner() {
    datawedgeServiceInterface.activeSessionScanner();
  }

  @override
  void onClose() {
    datawedgeServiceInterface.closeStreamController();
    super.onClose();
  }
}
