import 'package:MatrixScanSimpleSample/bloc/barcode_list_bloc.dart';
import 'package:MatrixScanSimpleSample/widgets/back_button_widget.dart';
import 'package:MatrixScanSimpleSample/widgets/clear_button_red.dart';
import 'package:MatrixScanSimpleSample/widgets/list_serials.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListBarcodeScreen extends StatefulWidget {
  const ListBarcodeScreen({Key? key}) : super(key: key);

  @override
  State<ListBarcodeScreen> createState() => _ListBarcodeScreenState();
}

class _ListBarcodeScreenState extends State<ListBarcodeScreen> {
  BarcodeListBloc barcodeListBloc = BarcodeListBloc();

  @override
  void initState() {
    barcodeListBloc.updateListTitles();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (context) => barcodeListBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  color: Colors.white38,
                  width: 300,
                  height: size.height,
                  padding: const EdgeInsets.only(top: 100, right: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackButtonWidget(
                            type: 0,
                            callback: () => Navigator.pop(context, false),
                          ),
                          ClearButtonRed(),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Resultados de Captura',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Color.fromRGBO(88, 181, 194, .7),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: barcodeListBloc.matrixBarcodes.keys.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Grupo  N°${index + 1}',
                                    style: TextStyle(color: Colors.grey, fontSize: 15),
                                  ),
                                ),
                                ListOfSerials(indexOfList: index)
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
