import 'dart:async';
import 'dart:convert';

import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';
import 'package:flutter/services.dart';

class DatawedgeService extends DatawedgeServiceInterface {
  final MethodChannel _methodChannel = const MethodChannel('com.compunet.almaviva/command');
  EventChannel scanChannel = const EventChannel("com.compunet.almaviva/scan");

  final StreamController<Map<int, List<String>>> _streamController =
      StreamController<Map<int, List<String>>>();
  final StreamController<List<String>> _streamListCodes = StreamController<List<String>>();

  Map<int, List<String>> matrixOfCodes = {1: [], 2: [], 3: [], 4: []};
  //variables
  int totalQuantity = 0;
  int cont = 0;
  List<String> listOfCodes = [];

  @override
  Stream<Map<int, List<String>>> get eventOnDatawedge => _streamController.stream;

  @override
  Stream<List<String>> get eventListOnDatawedge => _streamListCodes.stream;

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
    scanChannel.receiveBroadcastStream().listen((event) {
      var eventDecode = json.decode(event);

      if (eventDecode["data"].length > 1) {
        analyzeBarcodeList(eventDecode["data"].map((e) => e.toString()).toList());
      } else {
        if (cont <= totalQuantity) {
          print(eventDecode["data"]);
          listOfCodes.add(eventDecode["data"].last.toString());

          _streamListCodes.sink.add(listOfCodes);

          cont += 1;
        }
        if (cont == totalQuantity) {
          _sendDataWedgeCommand("com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "STOP_SCANNING");
          analyzeBarcodeList(listOfCodes);
        }
      }
    });
  }

  @override
  void resetReportInstantlyVariables() {
    cont = 0;
    listOfCodes = [];
  }

  @override
  void closeStreamController() {
    _streamController.close();
    _streamListCodes.close();
  }

  @override
  Future<void> activeSessionScanner() async {
    try {
      _sendDataWedgeCommand("com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "START_SCANNING");
    } catch (e) {
      print("Error :C : $e");
    }
  }

  @override
  Future<void> modifySettings({numberOfCodes, timer, reportInstantly, beamWidth, aimType}) async {
    // context: Context, numberOfBarcodesPerScan: Int, vbReportInstantly: Boolean, timer : Int, Beam_Width:Int}
    print("reporte $reportInstantly");
    try {
      String argumentAsJson = jsonEncode({
        "numberOfCodes": numberOfCodes,
        "timer": timer,
        "reportInstantly": reportInstantly,
        "aim_type": aimType,
        "beamWidth": beamWidth
      });

      var result = await _methodChannel.invokeMethod('setConfigDataWedge', argumentAsJson);
      print(result);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  @override
  void stablishMatrixOfCodes(Map<String, String> matrixReference) {
    matrixOfCodes = {};
    for (var value in matrixReference.values) {
      matrixOfCodes[list.indexOf(value)] = [];
    }
  }

  @override
  void stablishTotalQuantity(int quantity) {
    totalQuantity = quantity;
  }

  void analyzeBarcodeList(List<dynamic> barcodes) {
    int keysLenght = matrixOfCodes.keys.length;
    matrixOfCodes = separateListOfCodes(barcodes, keysLenght);
    _streamController.sink.add(matrixOfCodes);
    resetReportInstantlyVariables();
  }

  Map<int, List<String>> separateListOfCodes(List<dynamic> listOfCodes, int quantityOfCodes) {
    print("Cantidad: $quantityOfCodes");
    Map<int, List<String>> auxMatrix = {};
    List<int> keysOfMatrix = matrixOfCodes.keys.toList();
    int count = 0;
    int value = keysOfMatrix[count];
    print(keysOfMatrix);
    for (var barcode in listOfCodes) {
      if (count == quantityOfCodes) {
        count = 0;
      }
      value = keysOfMatrix[count];
      if (!auxMatrix.keys.contains(value)) auxMatrix[value] = [];
      print("$value ${barcode}");
      auxMatrix[value]!.add(barcode);
      count++;
    }
    return auxMatrix;
  }

  List<String> list = [
    "Serial number",
    "MAC",
    "CM MAC",
    "MTA MAC",
    "CHIP ID",
    "WANMAC",
    "HFC MAC",
    "ZT SN",
    "HOST",
    "NO/STB",
    "ID",
    "CA ID",
    "CABLE MAC",
    "EMTA MAT",
    "WAN",
    "EMEI",
    "No aplica",
  ];
}
