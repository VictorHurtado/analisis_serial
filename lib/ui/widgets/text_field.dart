import 'package:almaviva_app/domain/controllers/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFormFieldSettings extends StatefulWidget {
  final String title;
  const TextFormFieldSettings({Key? key, required this.title}) : super(key: key);

  @override
  State<TextFormFieldSettings> createState() => _TextFormFieldSettingsState();
}

class _TextFormFieldSettingsState extends State<TextFormFieldSettings> {
  final _settingsController = Get.find<SettingsController>();
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    editingController.text = _settingsController.settings[widget.title] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Obx(
        () => TextFormField(
          controller: editingController,
          onSaved: (newValue) {
            _settingsController.setValueOnSettings(widget.title, newValue);
          },
          validator: (value) {
            if (value == null || value.trim().length == 0 || value == '0') {
              return 'error campo nulo';
            }

            return null;
          },
          decoration: InputDecoration(
              hintText: _settingsController.settings[widget.title] ?? '',
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
    );
  }
}
