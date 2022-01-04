import 'dart:async';

import 'package:MatrixScanSimpleSample/db/db.dart';
import 'package:MatrixScanSimpleSample/methods/math_functions.dart';
import 'package:MatrixScanSimpleSample/models/barcode_location.dart';
import 'package:simple_cluster/simple_cluster.dart';

import 'bloc_base.dart';
import 'package:flutter/material.dart' as material;
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class MatrixMaterialScanBloc extends Bloc
    with material.ChangeNotifier
    implements BarcodeTrackingListener {
  late DataCaptureContext captureContext;
  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;
  late BarcodeTracking _barcodeTracking;
  late DataCaptureView captureView;

  static Feedback feedback = Feedback.defaultFeedback;

  List<String> resultScan = [];

  List<BarcodeLocation> scanResultString = [];

  Map<int, List<BarcodeLocation>> matrixBarcodes = {};
  Map<int, List<BarcodeLocation>> auxMatrix = {};

  //DBSCAN
  List<List<double>> points = [];

  //config material
  List<int> dimension = [6, 2];
  int quantityOfCodes = 3;

  double epsilon = 200;
  int minPoints = 2;
  int groups = 0;

  StreamController<bool> _isCapturingStreamController = StreamController();

  Stream<bool> get isCapturing => _isCapturingStreamController.stream;

  //Repository's

  MatrixMaterialScanBloc(this.captureContext) {
    _init();
  }
  BarcodeTrackingSettings get barcodeTrackingSettings {
    var captureSettings = BarcodeTrackingSettings();

    // The settings instance initially has all types of barcodes (symbologies) disabled. For the purpose of this
    // sample we enable a very generous set of symbologies. In your own app ensure that you only enable the
    // symbologies that your app requires as every additional enabled symbology has an impact on processing times.
    captureSettings.enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.upce,
      // Symbology.qr,
      // Symbology.dataMatrix,
      Symbology.code39,
      Symbology.code128,
      Symbology.interleavedTwoOfFive
    });
    _barcodeTracking = BarcodeTracking.forContext(captureContext, captureSettings)
      ..addListener(this);

    captureView = DataCaptureView.forContext(captureContext);

    captureView.addOverlay(
        BarcodeTrackingBasicOverlay.withBarcodeTrackingForView(_barcodeTracking, captureView));

    if (_camera != null) {
      captureContext.setFrameSource(_camera!);
    }

    _camera?.switchToDesiredState(FrameSourceState.on);
    _barcodeTracking.isEnabled = false;
    return captureSettings;
  }

  void _init() {
    var cameraSettings = BarcodeTracking.recommendedCameraSettings;
    cameraSettings.preferredResolution = VideoResolution.fullHd;
    _camera?.applySettings(cameraSettings);
    _barcodeTracking = BarcodeTracking.forContext(captureContext, barcodeTrackingSettings)
      ..addListener(this);

    var _viewfinder = RectangularViewfinder.withStyleAndLineStyle(
        RectangularViewfinderStyle.legacy, RectangularViewfinderLineStyle.light);
    _viewfinder.setSize(
        SizeWithUnit(DoubleWithUnit(20.0, MeasureUnit.dip), DoubleWithUnit(60.0, MeasureUnit.dip)));
    captureView.addOverlay(
      BarcodeTrackingAdvancedOverlay.withBarcodeTrackingForView(_barcodeTracking, captureView)
        ..shouldShowScanAreaGuides = true,
    );

    captureView = DataCaptureView.forContext(captureContext);
    captureView.pointOfInterest = PointWithUnit(
        DoubleWithUnit(0.5, MeasureUnit.fraction), DoubleWithUnit(0.5, MeasureUnit.fraction));

    BarcodeTrackingBasicOverlay.withBarcodeTrackingForView(_barcodeTracking, captureView);

    captureContext.setFrameSource(_camera!);
    switchCameraOn();
    _barcodeTracking.isEnabled = false;
  }

  void updateEpsilon(String newEpsilon) {
    print(newEpsilon);
    if (newEpsilon != '' && newEpsilon != null) {
      epsilon = double.parse(newEpsilon);
    }
    notifyListeners();
  }

  void updateMinPoints(String newMinPoints) {
    print(newMinPoints);
    if (newMinPoints != '' && newMinPoints != null) {
      minPoints = int.parse(newMinPoints);
    }
    notifyListeners();
  }

  void updateQuantityOfCodes(String newQuantity) {
    print(newQuantity);
    if (newQuantity != '' && newQuantity != null) {
      quantityOfCodes = int.parse(newQuantity);
    }
    notifyListeners();
  }

  void updateGroups(String newGroups) {
    print(newGroups);
    if (newGroups != '' && newGroups != null) {
      groups = int.parse(newGroups);
    }
    notifyListeners();
  }

  void captureBarcodeEnable() {
    if (_camera!.desiredState == FrameSourceState.on) {
      switchCameraOff();
      _isCapturingStreamController.sink.add(false);
    } else {
      switchCameraOn();
      _isCapturingStreamController.sink.add(true);
    }
    notifyListeners();
  }

  void resumeCapturing() {
    _isCapturingStreamController.sink.add(true);
    switchCameraOn();
  }

  void switchCameraOff() {
    _camera!.switchToDesiredState(FrameSourceState.off);
  }

  void switchCameraOn() {
    _camera!.switchToDesiredState(FrameSourceState.on);
  }

  @override
  void dispose() {
    _isCapturingStreamController.close();
    _barcodeTracking.removeListener(this);
    _barcodeTracking.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    captureContext.removeAllModes();

    super.dispose();
  }

  @override
  void didUpdateSession(BarcodeTracking barcodeTracking, BarcodeTrackingSession session) {
    // if (_barcodeTracking.isEnabled == true) {
    for (final trackedBarcode in session.addedTrackedBarcodes) {
      if (!resultScan.contains(trackedBarcode.barcode.data)) {
        addNewCode(trackedBarcode.barcode.data!);
        print("${trackedBarcode.barcode.data}${trackedBarcode.location.topLeft.toString()}");
        // updateSumH(trackedBarcode);
        scanResultString.add(BarcodeLocation(
            trackedBarcode.barcode.data!, trackedBarcode.location.topLeft.toMap(), 0));
      }

      //
    }
  }

  void addNewCode(String newBarcode) {
    resultScan.add(newBarcode);
    notifyListeners();
  }

  void capturedEnable() {
    _barcodeTracking.isEnabled = true;
    Future.delayed(Duration(seconds: 4)).whenComplete(() => _barcodeTracking.isEnabled = false);
  }

  void simpleClustering() {
    List<List<double>> dataset = valuesForClustering();
    print(dataset);
    DBSCAN dbscan = DBSCAN(
      epsilon: epsilon, // 200 para dos columnas y grupos 180 arris
      minPoints: minPoints,
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
    saveBarcodesInGroups(clusterOutput);
  }

  void saveBarcodesInGroups(List<List<int>> clusterOutput) {
    if (matrixBarcodes.isNotEmpty) matrixBarcodes.clear();
    for (var cluster in clusterOutput) {
      int index = clusterOutput.indexOf(cluster);
      for (var barcode in cluster) {
        print(scanResultString[barcode].barcode);
        if (matrixBarcodes.keys.contains(index)) {
          matrixBarcodes[index]!.add(scanResultString[barcode]);
        } else {
          matrixBarcodes[index] = [scanResultString[barcode]];
        }
      }
    }
    print(matrixBarcodes);
  }

  void printBarcodes(List<List<int>> clusterOutput) {
    for (var cluster in clusterOutput) {
      for (var barcode in cluster) {
        print(scanResultString[barcode].barcode);
      }
    }
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

  void sortByRow() {
    if (quantityOfCodes > 0 && groups == 1) {
      print("entre");
      auxMatrix.clear();
      for (var pivot in matrixBarcodes.keys) {
        print("ESTE ES EL PIVOTE $pivot");
        createNewTag(matrixBarcodes[pivot]!);
      }
      matrixBarcodes.clear();

      matrixBarcodes.addAll(auxMatrix);
    }
  }

  void createNewTag(List<BarcodeLocation> listOfCodes) {
    int count = 0;

    for (var barcode in listOfCodes) {
      if (count == quantityOfCodes) count = 0;
      if (!auxMatrix.keys.contains(count)) auxMatrix[count] = [];
      print("$count ${barcode.barcode}");
      auxMatrix[count]!.add(barcode);
      count++;
    }
  }

  void sortColumns() {
    if (matrixBarcodes.keys.isNotEmpty) {
      for (var pivot in matrixBarcodes.keys) {
        int high = matrixBarcodes[pivot]!.length - 1;
        int low = 0;
        quickSort(matrixBarcodes[pivot]!, low, high);
      }
    }
    printMatrixBarcodes();
  }

  void printMatrixBarcodes() {
    for (var key in matrixBarcodes.keys) {
      print("$key -----------------${matrixBarcodes[key]!.length}");

      for (var barcode in matrixBarcodes[key]!) {
        print("${barcode.barcode} ${barcode.location["x"].toString()} ");
      }
    }
  }

  void finishOrder() {
    var box = HiveDB.getBoxScanData();
    box.put("result", matrixBarcodes);
  }

  void resetScanResults() {
    auxMatrix.clear();
    matrixBarcodes.clear();
    scanResultString.clear();
    resultScan.clear();
  }
}
