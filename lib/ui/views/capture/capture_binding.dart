import 'package:almaviva_app/data/services/datawedge_service.dart';
import 'package:almaviva_app/domain/services/datawedge_service_interface.dart';
import 'package:get/get.dart';

import '../../../domain/controllers/controllers.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanController(datawedgeServiceInterface: DatawedgeService()));
  }
}
