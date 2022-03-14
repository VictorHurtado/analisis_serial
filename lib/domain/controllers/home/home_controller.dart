import 'package:get/get.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;

  HomeController();

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
