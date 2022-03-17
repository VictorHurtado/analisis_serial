import 'dart:async';
import 'dart:convert';

import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';
import 'package:flutter/services.dart';

class DatawedgeService extends DatawedgeServiceInterface {
  final MethodChannel _methodChannel = const MethodChannel('com.compunet.almaviva/command');
  EventChannel scanChannel = const EventChannel("com.compunet.almaviva/scan");

  final StreamController<Map<int, List<String>>> _streamController =
      StreamController<Map<int, List<String>>>();

  @override
  Stream<Map<int, List<String>>> get eventOnDatawedge => _streamController.stream;

  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson = jsonEncode({"command": command, "parameter": parameter});

      await _methodChannel.invokeMethod('sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  @override
  Future<void> printVersion() async {
    try {
      final result = await _methodChannel.invokeMethod("version");
      // ignore: avoid_print
      print(result);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Future<void> createProfile(String profileName) async {
    try {
      await _methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  @override
  void listenScanResult() {
    print("estoy escuchando un evento");
    scanChannel.receiveBroadcastStream().listen((event) {
      analyzeBarcodeList(json.decode(event)["data"].map((e) => e.toString()).toList());
    });
  }

  @override
  void closeStreamController() {
    _streamController.close();
  }

  @override
  Future<void> activeSessionScanner() async {
    print("activo sesión scanner");
    try {
      _sendDataWedgeCommand("com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "START_SCANNING");
    } catch (e) {
      print("Error :C : $e");
    }
  }

  void analyzeBarcodeList(List<dynamic> barcodes) {
    Map<int, List<String>> matrixOfCodes = {1: [], 2: []};
    int keysLenght = matrixOfCodes.keys.length;
    matrixOfCodes = separateListOfCodes(barcodes, keysLenght);
    print("barcode matrix: $matrixOfCodes");
  }

  Map<int, List<String>> separateListOfCodes(List<dynamic> listOfCodes, int quantityOfCodes) {
    Map<int, List<String>> auxMatrix = {};
    int count = 0;

    for (var barcode in listOfCodes) {
      if (count == quantityOfCodes) count = 0;
      if (!auxMatrix.keys.contains(count)) auxMatrix[count] = [];
      print("$count ${barcode}");
      auxMatrix[count]!.add(barcode);
      count++;
    }
    return auxMatrix;
  }
}
