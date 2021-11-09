/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:MatrixScanSimpleSample/barcode_location.dart';
import 'package:encrypt/encrypt.dart' as EC;
import 'dart:math';
import 'package:MatrixScanSimpleSample/main.dart';
import 'package:MatrixScanSimpleSample/scan_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'package:MatrixScanSimpleSample/modules/auxiliar_modules.dart';

class MatrixScanScreen extends StatefulWidget {
  final String title;
  final String licenseKey;

  MatrixScanScreen(this.title, this.licenseKey, {Key? key}) : super(key: key);

  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() =>
      _MatrixScanScreenState(DataCaptureContext.forLicenseKey(licenseKey));
}

class _MatrixScanScreenState extends State<MatrixScanScreen>
    with WidgetsBindingObserver
    implements BarcodeTrackingListener {
  final DataCaptureContext _context;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;
  late BarcodeTracking _barcodeTracking;
  late DataCaptureView _captureView;

  bool _isPermissionMessageVisible = false;
  bool captured = false;

  List<ScanResult> scanResults = [];
  List<BarcodeLocation> scanResultString = [];

  //creación de una matriz con  scandit
  String forward = "y";
  String reverse = "x";
  double sumH = 0;
  double tolerance = 0.5;
  double media = 0;
  double standarDesviation = 0;
  List<String> resultScan = [];
  List<BarcodeLocation> pivots = [];


  Map<double, List<BarcodeLocation>> matrixBarcodes = {};


  _MatrixScanScreenState(this._context);

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          _isPermissionMessageVisible = !value;
          if (value) {
            _camera?.switchToDesiredState(FrameSourceState.on);
          }
        }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    var cameraSettings = BarcodeTracking.recommendedCameraSettings;

    cameraSettings.preferredResolution = VideoResolution.fullHd;

    _camera?.applySettings(cameraSettings);

    _checkPermission();

    var captureSettings = BarcodeTrackingSettings();

    captureSettings.enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.upce,
      Symbology.code39,
      Symbology.code128,
    });

    _barcodeTracking = BarcodeTracking.forContext(_context, captureSettings)..addListener(this);

    _captureView = DataCaptureView.forContext(_context);

    _captureView.addOverlay(
      BarcodeTrackingBasicOverlay.withBarcodeTrackingForView(_barcodeTracking, _captureView)
        ..shouldShowScanAreaGuides = true,
    );

    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);
    _barcodeTracking.isEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = PlatformText('No permission to access the camera!',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      var bottomPadding = 48 + MediaQuery.of(context).padding.bottom;
      var containerPadding = defaultTargetPlatform == TargetPlatform.iOS
          ? EdgeInsets.fromLTRB(48, 48, 48, bottomPadding)
          : EdgeInsets.all(48);
      child = Stack(children: [
        _captureView,
        Container(
          alignment: Alignment.bottomCenter,
          padding: containerPadding,
          child: SizedBox(
              width: double.infinity,
              child: PlatformButton(
                  onPressed: () {
                    executeStaticsstatistical();
                    sortByColumns();
                    calculateRows();
                  },
                  cupertino: (_, __) => CupertinoButtonData(
                      color: Color(scanditBlue),
                      borderRadius: BorderRadius.all(Radius.circular(3.0))),
                  child: PlatformText(
                    'Done',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))),
        )
      ]);
    }
    return PlatformScaffold(appBar: PlatformAppBar(title: Text(widget.title)), body: child);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    } else if (state == AppLifecycleState.paused) {
      _camera?.switchToDesiredState(FrameSourceState.off);
    }
  }

  // This function is called whenever objects are updated and it's the right place to react to
  // the tracking results.

  @override
  void didUpdateSession(BarcodeTracking barcodeTracking, BarcodeTrackingSession session) {
    // if (_barcodeTracking.isEnabled == true) {
    for (final trackedBarcode in session.addedTrackedBarcodes) {
      scanResults
          .add(ScanResult(trackedBarcode.barcode.symbology, trackedBarcode.barcode.data ?? ''));
      if (!resultScan.contains(trackedBarcode.barcode.data)) {
        resultScan.add(trackedBarcode.barcode.data!);
        updateSumH(trackedBarcode);
        scanResultString.add(BarcodeLocation(
            trackedBarcode.barcode.data!, trackedBarcode.location.topLeft.toMap(), 0));
      }

      //
    }
  }

  void executeStaticsstatistical() {
    media = calculateMeanY(scanResultString, reverse);
    standarDesviation = calculateStandarDesviation(scanResultString, reverse, media);
    calculateTolerace();
    calculateValueForColumn(reverse);
  }

  // no se puede mover
  void updateSumH(TrackedBarcode trackedBarcode) {
    sumH = sumH +
        (trackedBarcode.location.bottomLeft.y -
            trackedBarcode
                .location.topLeft.y); // PILO CAMBIAR EJES MANUALES REVERSE = Y ORIENTATION = X
  }

  // no se puede mover
  void calculateTolerace() {
    tolerance = (standarDesviation / media) * calculateMeanH(sumH, scanResultString);
    print("Tolerancia2 : $tolerance");
  }

  //no se puede
  void calculateValueForColumn(String orientation) {
    for (BarcodeLocation barcode in scanResultString) {
      barcode.type = (barcode.location[orientation] / standarDesviation);
    }
  }

  void printScanResultString() {
    for (var barcode in scanResultString) {
      print(" -----------------${barcode.barcode}");
    }
  }

  void sortByColumns() {
    if (matrixBarcodes.isEmpty) {
      for (BarcodeLocation barcode in scanResultString) {
        insertIntoColumn(barcode);
      }
    } else {
      _resetScanResults();
    }
    printMatrixBarcodes();
  }

  void printMatrixBarcodes() {
    for (var key in matrixBarcodes.keys) {
      print("$key -----------------${matrixBarcodes[key]!.length}");

      for (var barcode in matrixBarcodes[key]!) {
        print("${barcode.barcode} ${barcode.type.toString()} ");



  void insertIntoColumn(BarcodeLocation barcode) {
    if (matrixBarcodes.keys.isEmpty) {
      matrixBarcodes.addAll({
        barcode.type: [barcode]
      });
    } else {
      for (var pivot in matrixBarcodes.keys) {
        if (barcode.type <= pivot + tolerance && barcode.type >= pivot - tolerance) {
          if (!matrixBarcodes[pivot]!.contains(barcode)) {
            matrixBarcodes[pivot]!.add(barcode);
          }

          return;
        }
      }

      matrixBarcodes[barcode.type] = [barcode];
    }
  }

  void calculateRows() {
    if (matrixBarcodes.keys.isNotEmpty) {
      for (var pivot in matrixBarcodes.keys) {
        int high = matrixBarcodes[pivot]!.length - 1;
        int low = 0;
        quickSort(matrixBarcodes[pivot]!, low, high);


  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _barcodeTracking.removeListener(this);
    _barcodeTracking.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
    super.dispose();
  }

  void _resetScanResults() {
    scanResults.clear();
    matrixBarcodes.clear();
    scanResultString.clear();
    resultScan.clear();
    pivots.clear();
    media = 0;
    standarDesviation = 0;
    sumH = 0;
  }
}
