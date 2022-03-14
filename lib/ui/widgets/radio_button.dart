import 'package:flutter/material.dart';

class RadioButtonSettings extends StatefulWidget {
  const RadioButtonSettings({Key? key}) : super(key: key);

  @override
  State<RadioButtonSettings> createState() => _RadioButtonSettingsState();
}

class _RadioButtonSettingsState extends State<RadioButtonSettings> {
  Set<bool> groupValue = {true, false};
  bool selected = true;
  @override
  Widget build(BuildContext context) {
    return Radio(
      value: groupValue.first,
      toggleable: true,
      groupValue: selected,
      onChanged: (bool? value) {
        setState(() {
          selected = value ?? false;
        });
        print(selected);
      },
    );
  }
}
