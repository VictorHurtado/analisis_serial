import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final int type;
  final VoidCallback callback;

  const BackButtonWidget({Key? key, required this.type, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        width: 30,
        height: 30,
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(88, 181, 194, .7),
            size: 30,
          ),
        ),
      ),
    );
  }
}
