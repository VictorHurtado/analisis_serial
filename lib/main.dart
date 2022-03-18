import 'package:almaviva_app/routes/routes.dart';
import 'package:almaviva_app/ui/main_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initServices();
  runApp(const MyApp());
}

void initServices() async {
  print('starting services ...');

  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.
  await Get.putAsync(() => DbService().init());
  print('All services started...');
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
