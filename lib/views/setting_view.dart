import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      height: Get.height - 60,
      child: Form(
        child: Column(
          children: [_inputForm(title: "Referenecia")],
        ),
      ),
    );
  }

  Widget _inputForm({title}) {
    print(Get.width * 0.034);
    final width = Get.width;
    final height = Get.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.03),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 3),
                    color: Colors.black12,
                  )
                ],
                border: Border.all(
                  width: 2,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: title,
                    errorStyle: const TextStyle(color: Colors.transparent, height: 0),
                    errorText: '',
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
