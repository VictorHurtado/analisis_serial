import 'package:flutter/material.dart';

class TextFormFieldSettings extends StatefulWidget {
  final String title;
  const TextFormFieldSettings({Key? key, required this.title}) : super(key: key);

  @override
  State<TextFormFieldSettings> createState() => _TextFormFieldSettingsState();
}

class _TextFormFieldSettingsState extends State<TextFormFieldSettings> {
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
      child: TextFormField(
        decoration: InputDecoration(
            hintText: widget.title,
            errorStyle: const TextStyle(color: Colors.transparent, height: 0),
            errorText: '',
            isDense: true,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }
}
