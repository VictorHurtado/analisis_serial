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
    'AWSQxT7KHgg/Ip+PXwcgLXInQkDtGo076FDzchVYcjIDR7oHNUgweT14hOk4XiiVW3mbbl94miCYYHLUuVeJIJtBjrWGe9Gtqx8kApFaRAPIRpIqDDTm/0wBLN1IRghsvjw/L6wdJdC26YZYOwvyJMCGGD/L+3t6IRO+cLaUB7rZjtiQ79cGaKOxU7F7gf/RnSbJOkyYOHc/3vb3V7PkD6tJtrP/AM21h3gKUJSMwGbrgPoPaPhhIUceCe3zC17FmLOk3T0oWa8TI7eGkds4Vq+GU6GLAPbpilNgYrbEE7uaJKO8vZu2HbWr4rR6eSG2GXVrlUfJSjoWeURyBC/bIfQ028Kz6vVy3uvKO4xbhm7WLS0mwG0F28IGm4hhech6+DxKAbD5Qg3I2OOYD3EGzDMNQcgn0kJp/vl6cqZTIe4YIGTFO8LTNiFjNFkQ72iRIuGVzN1xtydlfdvwEvge0mFNd44aKmjIpWhba6TaKB98mobXv0i9UBAHXdyfxYtydOPDiRwc5IHTxCHvNhHuNA+g/NFXU+YB/Z7j5Zb0mX20YEN4gZER2dtZnYVWYcPTX1JO4HZcjvp65qgTeVd0eRLK7flB/eR0q1FM2v7FThigktcghQely8BG8+4FnKkFsRJcbqtkhzGWaCY3bmKg5Av79fBFlNCL0iRJo9yfiUhjvOL2preVm0h7zVSmEQKhIlq4Raf2HYadHhHvxP88cNEv6C1vlAmQvUyYUD+6siOKH/JD4hsS8xtCZo4DP0SfWhFq/V3JdPvoooNRlOsYemiC4TndCUF+WmttZU+N3dR/dFFVVMY=';

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
        '/scanResults': (context) => ScanResultsScreen("Scan Results")
      },
    );
  }
}
