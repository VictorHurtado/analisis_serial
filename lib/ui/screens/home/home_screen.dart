import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:almaviva_app/ui/views/views.dart';
import 'package:almaviva_app/domain/controllers/controllers.dart';

class HomeScreen extends GetWidget<HomeController> {
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
            ),
          ],
        ),
        child: Obx(
          () => BottomNavigationBar(
            elevation: 8,
            selectedItemColor: Colors.red,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: "Capture",
                icon: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              BottomNavigationBarItem(
                label: "Configuración",
                icon: Icon(
                  Icons.settings,
                  size: 30,
                ),
              )
            ],
            currentIndex: homeController.selectedIndex.value,
            onTap: homeController.setSelectedIndex,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(
            () => Column(
              children: [_pages.elementAt(homeController.selectedIndex.value)],
            ),
          ),
        ),
      ),
    );
  }

  static final List<Widget> _pages = <Widget>[CaptureView(), const SettingsView()];
}
