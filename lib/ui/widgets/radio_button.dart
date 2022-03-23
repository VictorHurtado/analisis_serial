import 'package:almaviva_app/domain/controllers/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadioButtonSettings extends StatefulWidget {
  final String title;
  const RadioButtonSettings({Key? key, required this.title}) : super(key: key);

  @override
  State<RadioButtonSettings> createState() => _RadioButtonSettingsState();
}

class _RadioButtonSettingsState extends State<RadioButtonSettings> {
  Set<bool> groupValue = {true, false};
  final _settingsController = Get.find<SettingsController>();
  bool selected = true;
  @override
  Widget build(BuildContext context) {
    if (_settingsController.settings.isEmpty)
      selected = _settingsController.settings[widget.title] ?? true;
    return Radio(
      value: groupValue.first,
      toggleable: true,
      groupValue: selected,
      onChanged: (bool? value) {
        setState(() {
          selected = value ?? false;
        });
        _settingsController.setValueOnSettings(widget.title, value ?? false);
      },
    );
  }
}
