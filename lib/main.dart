/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:MatrixScanSimpleSample/models/barcode_location.dart';
import 'package:MatrixScanSimpleSample/views/matrix_scan_screen.dart';
import 'package:MatrixScanSimpleSample/views/scan_results_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  var path = getApplicationDocumentsDirectory();
  await Hive.initFlutter(path.toString());
  Hive.registerAdapter(BarcodeLocationAdapter());
  Hive.deleteBoxFromDisk('ScanData');

  await Hive.openBox('ScanData');

  runApp(MyApp());
}

const String licenseKey =
    'AcHg1BjdOPMgAqAj50HIbckJGXaUCWTHIWHqjo1+Oji9YaSvnko7nx0qlFKdXkalrFCuf1UMgvXaJd7bj2PWyg9MCFX0QAPKNzlYkppDDyRJHoObaTxTKeYx1s1ZCzniiThYgCI+z72GhP+u3O7LsqO6Fv0l9SuZeIwQOv19pl6aw0h6z49a/D2jx8MS+dJT/sJNkH8SSyDTikRIcIeGewVSwHWmuvfhNO2rd9WE1OUrFegwbwbkky3RU5C7sN5YcYwPsHlDzDWmcvRStmvBQ5vsdW9hhLnPHUIB5cHTAPIbAAX8CQPp24yhYD5j+Hlc5wD+LART+CWp0qkZG+sbOhF5GWRANuygKnBN+UnE0yubHIAskJHtJEB1g+Ozo7Bm+nS+oio8dqNcuBAHSKi5RONVM8+CS4p/Y1BK7Sg3h0q2S3N5OjE+K/VZkxBmFpwz6h/M9DoRq8ZBWyaHgVUCvZYaViCjIhb7MezIb7I8y/bMIP/mRzV61bQ5UAObPGuIcIcc0Pvh35iLrsYiEpORnkcyTMUkt064QBKsXGn/z2SILVBOSZ26MOEKmwfYX5XlIig1RPODZcJ8aVgVNfsJn7vYbsFBG9pPlNtN+h6aA7AWO70DUj/nd7ndOq82llb/JR2fBWlsqYfpurLtVbS9BgOchr0d/j9qe9TXsQ3XjWkf2nIXi+kQUjTAu2QioQsMY7aftxXpzQ/DpcoA5CfLRk/Zy8lIbQGhAGOAZ+m64W2RT1x3YSo3+p4zYjshf3+kfqgxD77NwdbYMAM/jmqNgTmUtdTLHRkxTb1fb2srl8KcK91L0oI=';

const int scanditBlue = 0xFF58B5C2;
const Map<int, Color> scanditBlueShades = {
  50: Color.fromRGBO(88, 181, 194, .1),
  100: Color.fromRGBO(88, 181, 194, .2),
  200: Color.fromRGBO(88, 181, 194, .3),
  300: Color.fromRGBO(88, 181, 194, .4),
  400: Color.fromRGBO(88, 181, 194, .5),
  500: Color.fromRGBO(88, 181, 194, .6),
  600: Color.fromRGBO(88, 181, 194, .7),
  700: Color.fromRGBO(88, 181, 194, .8),
  800: Color.fromRGBO(88, 181, 194, .9),
  900: Color.fromRGBO(88, 181, 194, 1),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      material: (_, __) => MaterialAppData(
          theme: ThemeData(
        buttonTheme: ButtonThemeData(
            buttonColor: const Color(scanditBlue), textTheme: ButtonTextTheme.primary),
        primarySwatch: MaterialColor(scanditBlue, scanditBlueShades),
        primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      )),
      cupertino: (_, __) =>
          CupertinoAppData(theme: CupertinoThemeData(brightness: Brightness.light)),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            MatrixScanScreen("MatrixScan Simple", (DataCaptureContext.forLicenseKey(licenseKey))),
        '/scanResults': (context) => ListBarcodeScreen()
      },
    );
  }
}
