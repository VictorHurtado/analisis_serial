import 'package:almaviva_app/domain/controllers/scan/scan_controller.dart';
import 'package:almaviva_app/ui/widgets/list_serials.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaptureView extends GetWidget<ScanController> {
  final _scanController = Get.find<ScanController>();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
        height: Get.height - 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _actionsContainer(),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  Obx(
                    () => SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (_scanController.matrixOfCodes.keys.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${list[index]}:',
                                style: TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListOfSerials(
                                  indexOfList: _scanController.matrixOfCodes.keys.toList()[index])
                            ],
                          );
                        } else {
                          return Text("Listas Vacías");
                        }
                      },
                      childCount: _scanController.matrixOfCodes.keys.length,
                    )),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _actionsContainer() {
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
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
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
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.red.shade600,
          ),
          child: Center(
            child: MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  _scanController.executeSettingModify();
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
