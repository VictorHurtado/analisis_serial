import 'package:almaviva_app/data/repository/local_database.dart';
import 'package:almaviva_app/data/services/datawedge_service.dart';
import 'package:almaviva_app/domain/controllers/controllers.dart';

import 'package:get/get.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanController(
          datawedgeServiceInterface: DatawedgeService(),
          databaseInterface: LocalDatabaseService(),
        ));
  }
}
