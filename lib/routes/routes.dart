import 'package:almaviva_app/ui/screens/home/home_binding.dart';
import 'package:almaviva_app/ui/screens/home/home_screen.dart';
import 'package:almaviva_app/ui/views/capture/capture_binding.dart';
import 'package:get/get.dart';

class DWRoutes {
  static const home = "/home";
}

class DWPages {
  static final pages = [
    GetPage(
        name: DWRoutes.home, page: () => HomeScreen(), bindings: [HomeBinding(), ScanBinding()]),
  ];
}
