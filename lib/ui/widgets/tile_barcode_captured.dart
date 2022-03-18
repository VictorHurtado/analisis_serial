import 'package:flutter/material.dart';

class TileBarcodeCaptured extends StatelessWidget {
  final String title;

  TileBarcodeCaptured({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        title: Text(
          this.title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
        ),
      ),
    );
  }
}
