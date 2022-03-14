import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListTileData extends StatelessWidget {
  String title;
  ListTileData({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      height: height * 0.07,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(4, 2))]),
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}
