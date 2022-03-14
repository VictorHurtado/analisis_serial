import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';

import 'package:get/get.dart';

class ScanController extends GetxController {
  final DatawedgeServiceInterface datawedgeServiceInterface;

  ScanController({required this.datawedgeServiceInterface});
  @override
  void onInit() {
    createProfileForScanning();
    datawedgeServiceInterface.listenScanResult();
    datawedgeServiceInterface.eventOnDatawedge.listen((event) {
      print("evento: $event");
    });
    super.onInit();
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
}
