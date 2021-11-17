/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:MatrixScanSimpleSample/barcode_location.dart';
import 'package:MatrixScanSimpleSample/scan_results_screen.dart';

import 'package:encrypt/encrypt.dart' as EC;
import 'dart:math';
import 'package:MatrixScanSimpleSample/main.dart';
import 'package:MatrixScanSimpleSample/scan_result.dart';
import 'package:simple_cluster/src/dbscan.dart';
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

  //creación de una matriz con  scandit
  String forward = "y";
  String reverse = "x";
  double sumH = 0;
  double tolerance = 0.5;
  double media = 0;
  double standarDesviation = 0;
  List<String> resultScan = [];
  List<BarcodeLocation> pivots = [];
  List<BarcodeLocation> scanResultString = [];

  Map<int, List<BarcodeLocation>> resultSort = {};
  Map<double, List<BarcodeLocation>> matrixBarcodes = {};

  //DBSCAN
  List<List<double>> points = [];

  //config material
  List<int> dimension = [6, 2];
  int quantityOfCodes = 3;

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
    _barcodeTracking.isEnabled = false;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  elevation: 8,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print("vamos a capturar");
                    capturedEnable();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  elevation: 8,
                  child: Icon(
                    Icons.calculate,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    simpleClustering();
                    // executeStaticsstatistical();
                    // sortByColumns();
                    // sortColumnsForRows();
                    // //sortByRow();
                    // removeExtraCodes();
                  },
                ),
              ),
            ],
          ),
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
        // updateSumH(trackedBarcode);
        scanResultString.add(BarcodeLocation(
            trackedBarcode.barcode.data!, trackedBarcode.location.topLeft.toMap(), 0));
      }

      //
    }
  }

  void capturedEnable() {
    _barcodeTracking.isEnabled = true;
    Future.delayed(Duration(seconds: 4)).whenComplete(() => _barcodeTracking.isEnabled = false);
  }

  List<List<double>> valuesForClustering() {
    points.clear();
    for (var barcode in scanResultString) {
      points.add(barcode.location.values.toList().cast<double>());
    }
    print(scanResultString.length);
    print(points.length);
    return points;
  }

  void simpleClustering() {
    List<List<double>> dataset = valuesForClustering();
    print(dataset);
    DBSCAN dbscan = DBSCAN(
      epsilon: 23, // 200 para dos columnas y grupos 180 arris
      minPoints: 2,
    );

    List<List<int>> clusterOutput = dbscan.run(dataset);
    print("===== 1 =====");
    print("Clusters output");
    print(clusterOutput); //or dbscan.cluster
    print("Noise");
    print(dbscan.noise);
    print("Cluster label for points");
    print(dbscan.label);

    printBarcodes(clusterOutput);
  }

  void printBarcodes(List<List<int>> clusterOutput) {
    for (var cluster in clusterOutput) {
      print("${cluster} GRUPO ");
      for (var barcode in cluster) {
        print(scanResultString[barcode].barcode);
      }
    }
  }
//   void executeStaticsstatistical() {
//     media = calculateMeanY(scanResultString, reverse);
//     standarDesviation = calculateStandarDesviation(scanResultString, reverse, media);
//     calculateTolerace();
//     calculateValueForColumn(reverse);
//   }

//   // no se puede mover
//   void updateSumH(TrackedBarcode trackedBarcode) {
//     sumH = sumH +
//         (trackedBarcode.location.bottomLeft.y -
//             trackedBarcode
//                 .location.topLeft.y); // PILO CAMBIAR EJES MANUALES REVERSE = Y ORIENTATION = X
//   }

//   // no se puede mover
//   void calculateTolerace() {
//     tolerance = (standarDesviation / media) * calculateMeanH(sumH, scanResultString);

//     print("Tolerancia2 : $tolerance");
//   }

//   //no se puede
//   void calculateValueForColumn(String orientation) {
//     for (BarcodeLocation barcode in scanResultString) {
//       barcode.type = (barcode.location[orientation] / standarDesviation);
//     }
//   }

//   void printScanResultString() {
//     for (var barcode in scanResultString) {
//       print(" -----------------${barcode.barcode}");
//     }
//   }

//   void sortByColumns() {
//     if (matrixBarcodes.isEmpty) {
//       for (BarcodeLocation barcode in scanResultString) {
//         insertIntoColumn(barcode);
//       }
//     } else {
//       _resetScanResults();
//     }
//   }

//   void printMatrixBarcodes() {
//     for (var key in matrixBarcodes.keys) {
//       print("$key -----------------${matrixBarcodes[key]!.length}");

//       for (var barcode in matrixBarcodes[key]!) {
//         print("${barcode.barcode} ${barcode.type.toString()} ");
//       }
//     }
//   }

//   void insertIntoColumn(BarcodeLocation barcode) {
//     if (matrixBarcodes.keys.isEmpty) {
//       matrixBarcodes.addAll({
//         barcode.type: [barcode]
//       });
//     } else {
//       for (var pivot in matrixBarcodes.keys) {
//         if (barcode.type <= pivot + tolerance && barcode.type >= pivot - tolerance) {
//           if (!matrixBarcodes[pivot]!.contains(barcode)) {
//             matrixBarcodes[pivot]!.add(barcode);
//           }

//           return;
//         }
//       }

//       matrixBarcodes[barcode.type] = [barcode];
//     }
//   }

//   void sortColumnsForRows() {
//     if (matrixBarcodes.keys.isNotEmpty) {
//       for (var pivot in matrixBarcodes.keys) {
//         int high = matrixBarcodes[pivot]!.length - 1;
//         int low = 0;
//         quickSort(matrixBarcodes[pivot]!, low, high);
//       }
//     }
//     printMatrixBarcodes();
//   }

// // REMOVER CODIGOS EXTRA
//   void removeExtraCodes() {
//     if (matrixBarcodes.keys.isNotEmpty) {
//       //removeBottomCodes();
//       removeSidesBarcodes();
//       removeTopCodes();
//     }

//     //printMatrixResult();
//   }

//   void removeBottomCodes() {
//     for (var pivot in matrixBarcodes.keys) {
//       if (matrixBarcodes[pivot]!.length != dimension[0]) {
//         matrixBarcodes[pivot] = matrixBarcodes[pivot]!
//             .getRange(
//               0,
//               dimension[0],
//             )
//             .toList();
//       }
//     }
//   }

//   void removeSidesBarcodes() {
//     for (var pivot in matrixBarcodes.keys) {
//       if (matrixBarcodes[pivot]!.length < dimension[1]) {
//         matrixBarcodes.remove(pivot);
//         return;
//       }
//     }
//   }

//   void removeTopCodes() {
//     var pivots = matrixBarcodes.keys.toList().asMap();
//     printMatrixBarcodes();
//     int row = 0;
//     while (row <= dimension[0]) {
//       for (var pivot in pivots.keys) {
//         // pivot es el indice de la llave

//         if (pivot != pivots.length - 1) {
//           print(" ${isSameRow(
//             extractCode(pivots, pivot, row),
//             extractCode(pivots, pivot + 1, row),
//           )}");
//         }
//       }
//       print(row);
//       row = row + 1;
//     }
//   }

//   BarcodeLocation extractCode(Map<int, double> pivots, int index, int row) {
//     if (matrixBarcodes[pivots[index]]!.length >= row) {
//       return matrixBarcodes[pivots[index]]![row];
//     } else {
//       return BarcodeLocation("barcode", {"x": 0, "y": 0}, 0);
//     }
//   }

//   bool isSameRow(BarcodeLocation firstCode, BarcodeLocation secondCode) {
//     var verticalTolerance = 50;
//     print("1 ${firstCode.barcode} - 2 ${secondCode.barcode}");
//     print("${firstCode.location["y"]} < ${secondCode.location["y"]}");

//     if (firstCode.location["y"] - verticalTolerance < secondCode.location["y"] &&
//         firstCode.location["y"] + verticalTolerance > secondCode.location["y"]) {
//       return true;
//     }

//     return false;
//   }

//   void sortByRow() {
//     if (quantityOfCodes > 0) {
//       for (var pivot in matrixBarcodes.keys) {
//         createNewTag(matrixBarcodes[pivot]!);
//       }
//     }
//   }

//   void createNewTag(List<BarcodeLocation> listOfCodes) {
//     int count = 0;

//     for (var barcode in listOfCodes) {
//       if (count == quantityOfCodes) count = 0;
//       if (!resultSort.keys.contains(count)) resultSort[count] = [];
//       resultSort[count]!.add(barcode);
//       count++;
//     }
//   }

//   void printMatrixResult() {
//     for (var key in resultSort.keys) {
//       print("$key -----------------${resultSort[key]!.length}");

//       for (var barcode in resultSort[key]!) {
//         print("${barcode.barcode} ${barcode.type.toString()} ");
//       }
//     }
//   }

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
    resultSort.clear();
    pivots.clear();
    media = 0;
    standarDesviation = 0;
    sumH = 0;
  }
}
