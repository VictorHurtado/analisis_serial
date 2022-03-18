import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DbService extends GetxService {
  Future<DbService> init() async {
    print('$runtimeType delays 2 sec');

    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    Hive.openBox('settings');

    print('$runtimeType ready!');
    return this;
  }
}
