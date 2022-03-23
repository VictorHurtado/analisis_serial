import 'package:almaviva_app/domain/repositories/local_database_interface.dart';
import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';

import 'package:get/get.dart';

class ScanController extends GetxController {
  final DatawedgeServiceInterface datawedgeServiceInterface;
  final LocalDatabaseInterface databaseInterface;
  var matrixOfCodes = {}.obs;
  var reportInstantly = false.obs;
  var listOfCodes = [].obs;

  ScanController({required this.datawedgeServiceInterface, required this.databaseInterface});
  @override
  void onInit() {
    createProfileForScanning();
    datawedgeServiceInterface.listenScanResult();
    datawedgeServiceInterface.eventOnDatawedge.listen((event) {
      print("evento: $event");
      matrixOfCodes.value = event;
    });
    datawedgeServiceInterface.eventListOnDatawedge.listen((event) {
      listOfCodes.add(event.last);
    });
    super.onInit();
  }

  Future<String> getSettingsOnDB() async {
    var settings = await databaseInterface.getValueFromKey("settings", "settings");
    if (settings.keys.isNotEmpty) {
      datawedgeServiceInterface
          .stablishMatrixOfCodes(Map<String, String>.from(settings["Serials"]));
      datawedgeServiceInterface.stablishTotalQuantity(int.parse(settings["Cantidad"]));
    }
    return settings.toString();
    // ignore: curly_braces_in_flow_control_structures
  }

  void printVersion() {
    datawedgeServiceInterface.printVersion();
  }

  void createProfileForScanning() {
    datawedgeServiceInterface.createProfile("DataWedgeFlutterDemo");
  }

  void activeSesionScanner() {
    listOfCodes.clear();
    datawedgeServiceInterface.activeSessionScanner();
  }

  @override
  void onClose() {
    datawedgeServiceInterface.closeStreamController();
    super.onClose();
  }
}
