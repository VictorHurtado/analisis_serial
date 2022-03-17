import 'dart:convert';

import 'package:hive/hive.dart';
part "setting_model.g.dart";

@HiveType(typeId: 0)
class SettingModel {
  @HiveField(0)
  String? reference;
  @HiveField(1)
  bool? groups;
  @HiveField(2)
  int? quantity;
  @HiveField(3)
  Map<String, int>? serialTy;

  SettingModel({
    this.groups,
    this.reference,
    this.quantity,
    this.serialTy,
  });

  factory SettingModel.fromJson(Map<String, dynamic> jsonIn) {
    return SettingModel(
        groups: jsonIn['groups'],
        quantity: jsonIn['quantity'],
        serialTy: json.decode(jsonIn['serialTy']),
        reference: jsonIn['reference']);
  }
  Map<String, dynamic> toJson() {
    return {
      "groups": groups,
      "quantity": quantity,
      "serialTy": json.encode(serialTy),
      "reference": reference
    };
  }
}
