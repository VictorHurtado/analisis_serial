import 'dart:async';

import 'package:MatrixScanSimpleSample/db/db.dart';
import 'package:MatrixScanSimpleSample/models/barcode_location.dart';

import 'bloc_base.dart';

import 'package:flutter/cupertino.dart';

class BarcodeListBloc extends Bloc with ChangeNotifier {
  Map<int, List<BarcodeLocation>> matrixBarcodes = {};

  Stream<int> get messagePopUp => _messagePopUp.stream;

  StreamController<int> _messagePopUp = StreamController();

  void updateListTitles() {
    var box = HiveDB.getBoxScanData();

    matrixBarcodes.addAll(box.get("result"));

    notifyListeners();
  }

  void clearBarcodes() {
    var box = HiveDB.getBoxScanData();
    matrixBarcodes.clear();
    box.put('result', matrixBarcodes);
    notifyListeners();
  }

  void discardBarcode(int indexOfList, int index) {
    var box = HiveDB.getBoxScanData();
    matrixBarcodes[indexOfList]!.removeAt(index);

    box.put('result', matrixBarcodes);
    notifyListeners();
  }

  @override
  void dispose() {
    _messagePopUp.close();
    super.dispose();
  }
}
