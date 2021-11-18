/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:MatrixScanSimpleSample/bloc/matrix_scan_bloc.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import '';

class MatrixScanScreen extends StatefulWidget {
  final String title;
  DataCaptureContext dataCaptureContext;

  MatrixScanScreen(this.title, this.dataCaptureContext, {Key? key}) : super(key: key);

  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() =>
      _MatrixScanScreenState(MatrixMaterialScanBloc(dataCaptureContext));
}

class _MatrixScanScreenState extends State<MatrixScanScreen> with WidgetsBindingObserver {
  MatrixMaterialScanBloc _bloc;
  bool _isPermissionMessageVisible = false;
  bool captured = false;
  //creación de una matriz con  scandit

  _MatrixScanScreenState(this._bloc);

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _checkPermission();
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
        _bloc.captureView,
        Container(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  heroTag: "btcapture",
                  elevation: 8,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print("vamos a capturar");
                    _bloc.capturedEnable();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  heroTag: "btresult",
                  elevation: 8,
                  child: Icon(
                    Icons.calculate,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _bloc.simpleClustering();
                    _bloc.finishOrder();
                    Navigator.pushNamed(context, '/scanResults').then((value) {
                      _bloc.switchCameraOff();
                      _bloc.switchCameraOn();
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ]);
    }
    return ChangeNotifierProvider(
        create: (context) => _bloc,
        child: Scaffold(appBar: AppBar(title: Text(widget.title)), body: child));
  }

  void _checkPermission() {
    if (mounted)
      Permission.camera.request().isGranted.then((value) => setState(() {
            _isPermissionMessageVisible = !value;
            if (value) {
              _bloc.switchCameraOn();
            }
          }));
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }
}
