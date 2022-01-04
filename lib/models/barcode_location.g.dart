// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodeLocationAdapter extends TypeAdapter<BarcodeLocation> {
  @override
  final int typeId = 0;

  @override
  BarcodeLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodeLocation(
      fields[1] as String,
      (fields[2] as Map).cast<String, dynamic>(),
      fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BarcodeLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.barcode)
      ..writeByte(2)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
