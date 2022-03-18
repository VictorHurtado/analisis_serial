import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';

import 'package:get/get.dart';

class ScanController extends GetxController {
  final DatawedgeServiceInterface datawedgeServiceInterface;
  var matrixOfCodes = {}.obs;

  ScanController({required this.datawedgeServiceInterface});
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

  void executeSettingModify() {
    datawedgeServiceInterface.modifySettings(
        numberOfCodes: 40, timer: 50000, reportInstantly: false, beamWidth: 0);
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
