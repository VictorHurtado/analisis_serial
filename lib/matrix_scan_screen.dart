/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:MatrixScanSimpleSample/barcode_location.dart';
import 'package:encrypt/encrypt.dart' as EC;

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
  List<String> scanResultString = [];

  //creación de una matriz con  scandit

  final double tolerance = 20;

  List<BarcodeLocation> pivots = [];
  Map<String, String> configBarcode = {
    "1": "13C4DG136305747",
    "2": "A8705DAFCDDC",
    "3": "A8705DAFCDDD",
    "4": "A8705DAFCDDE"
  };

  Map<String, List<BarcodeLocation>> matrixBarcodes = {};

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
                    print(" HOLA  ${jsonEncode(matrixBarcodes)}");
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

      print(
          "este es el pivote: ${trackedBarcode.barcode.data} y este es el valor ${trackedBarcode.location.topLeft.toMap()}");
      if (!scanResultString.contains(trackedBarcode.barcode.data)) {
        addAllKeysMatrix();
        extractLocationsOfPivot(trackedBarcode);
        if (pivots.length >= configBarcode.keys.length) {
          verifyWithPivot(trackedBarcode);
        }
      }

      //
    }
  }

  void extractLocationsOfPivot(TrackedBarcode trackedBarcode) {
    for (var key in configBarcode.keys) {
      if (configBarcode[key] == trackedBarcode.barcode.data) {
        pivots.add(BarcodeLocation(
            trackedBarcode.barcode.data!, trackedBarcode.location.topLeft.toMap(), key));
        print(pivots.length);
        return;
      }
    }
  }

  void verifyWithPivot(TrackedBarcode trackedBarcode) {
    print("${trackedBarcode.barcode.data}${trackedBarcode.location.topLeft.toMap()}");
    for (var pivot in pivots) {
      if (trackedBarcode.location.topLeft.x <= pivot.location["x"] + tolerance &&
          trackedBarcode.location.topLeft.x >= pivot.location["x"] - tolerance) {
        print(
            "este es el pivote: ${pivot.toMap()} y este es el valor ${trackedBarcode.location.topLeft.toMap()}");
        verifySortInColumn(trackedBarcode, pivot.type);
        scanResultString.add(trackedBarcode.barcode.data ?? '');
      }
    }
  }

  void verifySortInColumn(TrackedBarcode trackedBarcode, String pivotType) {
    if (trackedBarcode.location.topLeft.y < matrixBarcodes[pivotType]!.first.location['y']) {
      if (!matrixBarcodes[pivotType]!.contains(trackedBarcode.barcode.data))
        matrixBarcodes[pivotType]!.insert(
            0,
            BarcodeLocation(
                trackedBarcode.barcode.data!, trackedBarcode.location.topLeft.toMap(), pivotType));
    } else {
      if (!matrixBarcodes[pivotType]!.contains(trackedBarcode.barcode.data))
        matrixBarcodes[pivotType]!.add(BarcodeLocation(
            trackedBarcode.barcode.data!, trackedBarcode.location.topLeft.toMap(), pivotType));
    }
  }

  void addAllKeysMatrix() {
    if (matrixBarcodes.isEmpty) {
      for (var key in configBarcode.keys) {
        matrixBarcodes.addAll({key: []});
      }
    }
  }

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
  }
}
