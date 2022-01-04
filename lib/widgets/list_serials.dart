import 'package:MatrixScanSimpleSample/bloc/barcode_list_bloc.dart';
import 'package:MatrixScanSimpleSample/widgets/tile_barcode_captured.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfSerials extends StatelessWidget {
  final int indexOfList;

  ListOfSerials({Key? key, required this.indexOfList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BarcodeListBloc>(
      builder: (_, _bloc, __) {
        if (_bloc.matrixBarcodes.isNotEmpty && _bloc.matrixBarcodes.keys.contains(indexOfList)) {
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemCount: _bloc.matrixBarcodes[this.indexOfList]!.length,
            itemBuilder: (context, index) {
              var item = TileBarcodeCaptured(
                  title:
                      "${_bloc.matrixBarcodes[this.indexOfList]!.length - index}. ${_bloc.matrixBarcodes[this.indexOfList]![index].barcode}");
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    _bloc.discardBarcode(indexOfList, index);
                  },
                  child: item);
            },
          );
        } else {
          return Column(children: [Text("Vacío")]);
        }
      },
    );
  }
}
