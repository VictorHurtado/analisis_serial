import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaptureView extends StatelessWidget {
  const CaptureView({Key? key}) : super(key: key);

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
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text("Texto de Prueba, index $index")),
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
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700),
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
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                ),
                onPressed: () => print("Escaneando")),
          ),
        ),
      ],
    );
  }
}
