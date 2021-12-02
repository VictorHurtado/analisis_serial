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
    'AZvARAxTLam2KcZlTzPEbPQbxArdCR3/zENFnGM/ejTgYjV9nVPTNw5x1DZ+aMkzj1gGAyhcFYj/SW3K4xcLp81wZwnyJtXo3yzQy9tKzgAlcl+BL2EGtU5e2wGqZqBjoXd2fDt9iiNyVM9AEH65oxBWJIdhVcQZNineXX5m7dXzTCA+m1PIsa1/r1v/SL3zWHTP939FsCajVHJ9yX+VSZtIVlecSMha2mDtn3lom6WhIZ0dZ1XTTnJJkrvcfPnSSlSkHpRBoRikcTg5KWU7fYZEMY5oa8eaQAhvPV8jiOAqeqB/JkGLZNFif6l9ZM2B8VaDGRdRlXpZREXKAWbMBZx9iiK/dMR77n+WfcBSp5YEYoQk9yqpGEh1+XC3SIwFr3s1eSJNTgdPSrLQhl4y0QhbP5WcSSVOdiMAJJZYRTXJeJwLe3lxxYVFwSFNTEBO3UILe/hlc84cKUWqzU/r8ttUVwApZ0QOIFM0DhhzgsH6QNcoP0VLGvdOl1LtcBh0kRGhdq0Z/TGVIKTtug1Kb9gSUeMrOXnD7ORIrm323j44sr7lM17yCnSOCAQRSMf66Lo8Q8WCZt1f1T/53iswdHXVoYB9EKqd9AihevxLCgLVD6SZARkUZgO58ZPNzeksSiTsZQMiT3LHlxzSBiaMq50AoKz6/+f2HHq4AbikV+wJQsKJlgc9ir+7Kh2aGcbt+PBeD5o1wt2Xrh1J+wLO2DkUtdSNSYfFG8lnIR5I8dm80GzOA+n+a/yKWHZVEtTWqa0pstBQrPwTKG2iC6k33td/+HriJJm0yJZ4D9x1y86cpgRXymQJI77modlFKnCm0wbaE5/WJlWSUNE7qSPlQYjBRhgFpUqjukm+6Ko+pwwxVSILIR6JfgXpuhifgAUwlJqLPP0/FUKDnBmAzTRAGc6MJesbWSlf1myQGmfjOqcvIP8WvnbefCJP2FTKmSUeQyu0ZmOzFybQ9HTBROGLVYCkyLTqg84EPI2uhX7ML9dswvgt9QzFBsUL5w5JhH2LfJZsYKomdac1vAq55kOGAmV1FsDIY5gRxpbMgFNAMIjiGAxV6UGQMS/vBru/iwpY/MgSbQzs24P1XnsiYCC0NDCNagjMTqltKZBYP7DgymkYQAU1dCq+/RDtW+7GQMhDkyUu37T2lXcmB8jtWyyl3wRlh2E/Rwie7U3qEXb6oHD3/AUDZcw189Zk5swl+vfp';

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
