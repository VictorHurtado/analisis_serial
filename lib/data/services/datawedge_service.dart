import 'dart:async';
import 'dart:convert';

import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';
import 'package:flutter/services.dart';

class DatawedgeService extends DatawedgeServiceInterface {
  final MethodChannel _methodChannel = const MethodChannel('com.compunet.almaviva/command');
  EventChannel scanChannel = const EventChannel("com.compunet.almaviva/scan");

  final StreamController<String> _streamController = StreamController<String>();

  @override
  Stream<String> get eventOnDatawedge => _streamController.stream;

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
      _streamController.sink.add(event);
    });
  }

  @override
  void closeStreamController() {
    _streamController.close();
  }

  @override
  Future<void> activeSessionScanner() async {
    try {
      _sendDataWedgeCommand("com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "START_SCANNING");
      await Future.delayed(Duration(seconds: 2)).then((value) =>
          _sendDataWedgeCommand("com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "STOP_SCANNING"));
    } catch (e) {
      print("Error :C : $e");
    }
  }
}
