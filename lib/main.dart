import 'package:almaviva_app/routes/routes.dart';
import 'package:almaviva_app/ui/main_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Almaviva Lecture Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: DWRoutes.home,
      getPages: DWPages.pages,
      initialBinding: MainBinding(),
    );
  }
}
