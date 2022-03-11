import 'package:almaviva_app/views/setting_view.dart';
import 'package:almaviva_app/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  //New
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
        child: BottomNavigationBar(
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
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped, //New
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [_pages.elementAt(_selectedIndex)],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _pages = <Widget>[CaptureView(), SettingsView()];
}
