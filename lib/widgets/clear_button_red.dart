import 'package:MatrixScanSimpleSample/bloc/barcode_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClearButtonRed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _bloc = Provider.of<BarcodeListBloc>(context, listen: false);
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Color.fromRGBO(88, 181, 194, .7),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Center(
        child: TextButton(
          onPressed: () {
            _bloc.clearBarcodes();
          },
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
