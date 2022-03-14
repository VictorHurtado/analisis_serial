import 'package:almaviva_app/domain/controllers/scan/scan_controller.dart';
import 'package:almaviva_app/ui/widgets/tile_barcode.dart';
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
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTileData(title: "${index + 1} - barcode "),
                    childCount: 10,
                  )),
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
          style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w700),
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
      ],
    );
  }
}
