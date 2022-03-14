import 'package:almaviva_app/data/services/datawedge_service.dart';
import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';
import 'package:get/instance_manager.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatawedgeServiceInterface>(() => DatawedgeService());
  }
}
