import 'package:hive_flutter/hive_flutter.dart';
part "barcode_location.g.dart";

@HiveType(typeId: 0)
class BarcodeLocation {
  @HiveField(0)
  double type;
  @HiveField(1)
  String barcode;
  @HiveField(2)
  Map<String, dynamic> location;
  @HiveField(3)
  DateTime dateTime;
  BarcodeLocation(this.barcode, this.location, this.type, this.dateTime);

  Map<String, dynamic> toJson() {
    return {"barcode": barcode, "location": location, "type": type};
  }
}
