import 'package:almaviva_app/ui/widgets/combobox.dart';
import 'package:almaviva_app/ui/widgets/radio_button.dart';
import 'package:almaviva_app/ui/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputWidget extends StatefulWidget {
  final String title;
  final String type;
  const InputWidget({Key? key, required this.title, required this.type}) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          Expanded(child: _selectedType(title: widget.title, type: widget.type)),
        ],
      ),
    );
  }

  Widget _selectedType({title, type}) {
    switch (type) {
      case 'text':
        return TextFormFieldSettings(title: title);
      case 'radio':
        return RadioButtonSettings(title: title);
      case 'dropdown':
        return ComboInputWidget(
          title: title,
        );
      default:
        return Center(child: Text('Campo no disponible'));
    }
  }
}
