// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmProductAdapter extends TypeAdapter<FarmProduct> {
  @override
  final int typeId = 0;

  @override
  FarmProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FarmProduct(
      id: fields[0] as String,
      name: fields[1] as String,
      date: fields[2] as String,
      unit: fields[3] as String,
      tracking: (fields[4] as List).cast<String>(),
      harvestDate: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FarmProduct obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.tracking)
      ..writeByte(5)
      ..write(obj.harvestDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
