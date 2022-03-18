import 'package:almaviva_app/domain/controllers/scan/scan_controller.dart';
import 'package:almaviva_app/ui/widgets/tile_barcode_captured.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfSerials extends GetWidget<ScanController> {
  final int indexOfList;

  final scanController = Get.find<ScanController>();

  ListOfSerials({Key? key, required this.indexOfList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          itemCount: scanController.matrixOfCodes[indexOfList]!.length,
          itemBuilder: (context, index) {
            var item = TileBarcodeCaptured(
                title:
                    "${scanController.matrixOfCodes[indexOfList]!.length - index}. ${scanController.matrixOfCodes[indexOfList]![index]}");
            return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  print("Eliminado");
                },
                child: item);
          },
        ));
  }
}
