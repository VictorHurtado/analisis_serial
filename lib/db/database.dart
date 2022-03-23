import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DbService extends GetxService {
  Future<DbService> init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.deleteBoxFromDisk('settings');
    Hive.openBox('settings');

    print('$runtimeType ready!');
    return this;
  }
}
