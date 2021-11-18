import 'package:hive/hive.dart';

class HiveDB {
  static Box getBoxScanData() => Hive.box('ScanData');
}
