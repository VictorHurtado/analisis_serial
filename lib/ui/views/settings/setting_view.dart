import 'package:almaviva_app/domain/controllers/settings/settings_controller.dart';
import 'package:almaviva_app/ui/widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _settingsController = Get.find<SettingsController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      height: Get.height - 60,
      child: Stack(children: [
        Form(
          key: formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _titleSection(title: "Información del Material"),
              const InputWidget(title: "Cantidad", type: 'text'),
              const InputWidget(title: "Temporizador", type: 'text'),
              const InputWidget(title: "Reporte", type: 'radio'),
              // const InputWidget(title: "Grupos", type: 'radio'),
              _titleSection(
                title: "Configuración de estructura serial",
              ),
              const InputWidget(title: "Serial 1", type: 'dropdown'),
              const InputWidget(title: "Serial 2", type: 'dropdown'),
              const InputWidget(title: "Serial 3", type: 'dropdown'),
              const InputWidget(title: "Serial 4", type: 'dropdown'),
              const SizedBox(height: 100)
            ],
          ),
        ),
        _floatingActionButton(),
      ]),
    );
  }

  Widget _floatingActionButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.all(Get.height * 0.04),
        width: double.infinity,
        height: 50,
        decoration: const BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: MaterialButton(
            child: const Text("Guardar", style: TextStyle(color: Colors.white)),
            onPressed: () => _saveForm()),
      ),
    );
  }

  Widget _titleSection({title}) => Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w300),
        ),
      );
  bool _saveForm() {
    if (!formKey.currentState!.validate()) return false;
    formKey.currentState!.save();
    _settingsController.printSettings();
    _settingsController.executeSettingModify();

    return true;
  }
}
