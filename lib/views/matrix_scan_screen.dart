/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:MatrixScanSimpleSample/bloc/matrix_scan_bloc.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
        Consumer<MatrixMaterialScanBloc>(
          builder: (_, _bloc, __) => Text(
            "epsilon: ${_bloc.epsilon}\nMinxCluster: ${_bloc.minPoints}\ngroups: ${_bloc.groups == 0 ? false : true}\nCódigosxMat:${_bloc.quantityOfCodes}\nCapturados:${_bloc.resultScan.length}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: FloatingActionButton(
                  heroTag: "btconfig",
                  elevation: 8,
                  mini: true,
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print("Configuración");
                    _showDialog(_bloc.groups);
                  },
                ),
              ),
            ],
          ),
        ),
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
                    _bloc.sortColumns();
                    _bloc.sortByRow();
                    _bloc.finishOrder();
                    _bloc.switchCameraOff();
                    Navigator.pushNamed(context, '/scanResults').then((value) {
                      _bloc.switchCameraOff();
                      _bloc.switchCameraOn();
                      _bloc.resetScanResults();
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

  _showDialog(int groups) async {
    int? groupValue = groups;
    await showDialog<String>(
      context: context,
      builder: (
        context,
      ) =>
          _SystemPadding(
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      autofocus: true,
                      decoration: InputDecoration(labelText: 'Epsilon', hintText: '200'),
                      onSaved: (value) {
                        _bloc.updateEpsilon(value.toString());
                      },
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: 'Min. Elementos', hintText: '2'),
                      onSaved: (value) {
                        _bloc.updateMinPoints(value.toString());
                      },
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: 'Cantidad de codigos', hintText: '3'),
                      onSaved: (value) {
                        _bloc.updateQuantityOfCodes(value.toString());
                      },
                    ),
                    Row(
                      children: [
                        Text("¿Por Grupos?"),
                        Radio(
                          value: 1,
                          groupValue: groupValue,
                          toggleable: true,
                          onChanged: (int? value) {
                            if (_bloc.groups == 0) {
                              _bloc.updateGroups("1");
                            } else {
                              _bloc.updateGroups("0");
                            }
                            setState(() {
                              groupValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  validateForm();
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  void validateForm() {
    if (formKey.currentState != null) {
      print("Hola");
      formKey.currentState!.save();
    }
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets, duration: const Duration(milliseconds: 300), child: child);
  }
}
