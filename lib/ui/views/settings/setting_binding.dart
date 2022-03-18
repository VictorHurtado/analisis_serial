import 'package:almaviva_app/data/services/datawedge_service.dart';
import 'package:almaviva_app/domain/controllers/settings/settings_controller.dart';
import 'package:get/get.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController(
          datawedgeServiceInterface: DatawedgeService(),
        ));
  }
}
