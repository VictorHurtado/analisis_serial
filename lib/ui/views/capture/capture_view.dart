import 'package:almaviva_app/domain/controllers/scan/scan_controller.dart';
import 'package:almaviva_app/ui/widgets/list_serials.dart';
import 'package:almaviva_app/ui/widgets/tile_barcode_captured.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaptureView extends GetWidget<ScanController> {
  final _scanController = Get.find<ScanController>();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
        height: Get.height - 60,
        child: Stack(
          children: [
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionsContainer(),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              print("evento de lista: ${_scanController.listOfCodes}");
                              var item = TileBarcodeCaptured(
                                  title:
                                      "${_scanController.listOfCodes.length - index}. ${_scanController.listOfCodes[index]}");
                              return item;
                            },
                            childCount: _scanController.listOfCodes.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    height: 2,
                  ),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (_scanController.matrixOfCodes.keys.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _scanController.matrixOfCodes.keys.elementAt(index) <= 16
                                        ? '${list[_scanController.matrixOfCodes.keys.elementAt(index)]}:'
                                        : "Escaneado",
                                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListOfSerials(
                                      indexOfList:
                                          _scanController.matrixOfCodes.keys.toList()[index]),
                                ],
                              );
                            } else {
                              return Text("Listas Vacías");
                            }
                          },
                          childCount: _scanController.matrixOfCodes.keys.length,
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 300,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.redAccent,
                ),
                child: Center(
                  child: MaterialButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _scanController.activeSesionScanner();
                      }),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _actionsContainer() {
    TextEditingController editingController = TextEditingController();
    return Row(
      children: [
        const Text(
          "Resultados de Escaneo",
          style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const Expanded(child: SizedBox()),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: Colors.red.shade600,
          ),
          child: Center(
            child: MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Icon(
                  Icons.update,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Get.defaultDialog(
                    title: "Configuración Aplicada",
                    content: TextField(
                      controller: editingController..text = await _scanController.getSettingsOnDB(),
                    ),
                    contentPadding: const EdgeInsets.all(30),
                    titleStyle: const TextStyle(color: Colors.redAccent, fontSize: 17),
                    titlePadding: const EdgeInsets.all(30),
                  );
                }),
          ),
        ),
      ],
    );
  }

  List<String> list = [
    "Serial number",
    "MAC",
    "CM MAC",
    "MTA MAC",
    "CHIP ID",
    "WANMAC",
    "HFC MAC",
    "ZT SN",
    "HOST",
    "NO/STB",
    "ID",
    "CA ID",
    "CABLE MAC",
    "EMTA MAT",
    "WAN",
    "EMEI",
    "No aplica",
  ];
}
