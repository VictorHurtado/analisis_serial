import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/controllers/controllers.dart';

class ComboInputWidget extends StatefulWidget {
  final String title;
  const ComboInputWidget({Key? key, required this.title}) : super(key: key);

  @override
  State<ComboInputWidget> createState() => _ComboInputWidgetState();
}

class _ComboInputWidgetState extends State<ComboInputWidget> {
  final _settingsController = Get.find<SettingsController>();
  String selectedItem = "No aplica";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 3),
              color: Colors.grey.shade300,
            )
          ],
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(40))),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            items: list.map<DropdownMenuItem<String>>((String serialType) {
              return DropdownMenuItem<String>(
                value: serialType,
                child: Text(
                  serialType,
                  style: const TextStyle(color: Color(0xFF757575), fontSize: 12),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedItem = value.toString();
                _settingsController.setValueOnSettings(widget.title, value.toString());
              });
            },
            hint: Obx(() {
              if (_settingsController.settings.isNotEmpty)
                return _settingsController.settings["Serials"].keys.contains(widget.title)
                    ? Text(_settingsController.settings["Serials"][widget.title])
                    : Text("No aplica");
              return Text("No aplica");
            }),
          ),
        ),
      ),
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
