/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:MatrixScanSimpleSample/matrix_scan_screen.dart';
import 'package:MatrixScanSimpleSample/scan_results_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  runApp(MyApp());
}

const String licenseKey =
    'AcjQPxnTOcT/Qs9aMD3PefEY0SQUD2S2UksZKFZ6kYnYTVEdzVzYBw161Pp5QlXmDkL6yfobu6shQO/VD1NqoftK/MFcJ4tLcRse189k2lP6bcCuCDmCbmkjCThaHioXZQ+EyFwG5BTQJgWE+fPCj9PTwxYbvaYGJYCpy2bq1+rJwHf+M8Q8kTbyP4xRekiiyOhy/OOTy5xDOS2cYY8w0bVQNh1sFpJljCr4bn0JY0RKV1YRoNK/J/ohGBRLTYAxJ429kuxx4QFOtMfN9Fjr43G8gDLSp5tuMx7VQoPoBQtunJ3HPjo8+PwC/OwWKLyaeCvyoDJrzJCr46LaaMFFZvCJxp0V/KaKo5L2ZSX1dyDNQEiP594kWYBHyD9Z5KD9xisLMlb+/3eOHeb3vIkvp3jlTlQiOuzdkM0qQhAzW7Gl/xsyyhg6NbuyjyHUEBcSEcsn3YVzzIcSVczqgnXopUvKsECcbO8j0he/LcbALwXmdt32bCgZxE9knTVzU/fBVC6jH80CjxqhQ+0t9d/1ub/HgJnzLxtwILhaP3uhgimZT8Cvit6OghPDDSAOEYdIE2GaPBai6xMqNQNtnyZVDbNP2G8xtKRNNAaZmSNhkbQsq7VWtbxjNVeGvHgioKIT8nxUH13V3fhLbAGhnHGu9p5LZOttR0afHn1s+vBMijNMgTbY83c2sVJBJUeu5S0tY51a4FlknQSpG+WZiQ4I5a66qGPfqKHqo995O1kev9MwzfSxG9AEM9qlGkkBSwL+sCDI+RHSfjFqppqczOcNfi+ppn6tkRLUjFMourSWMYGhH9jvnxY=';

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
        '/': (context) => MatrixScanScreen("MatrixScan Simple", licenseKey),
        '/scanResults': (context) => ScanResultsScreen()
      },
    );
  }
}
