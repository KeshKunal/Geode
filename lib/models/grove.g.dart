// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grove.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroveAdapter extends TypeAdapter<Grove> {
  @override
  final int typeId = 2;

  @override
  Grove read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grove(
      id: fields[0] as String?,
      completedAt: fields[1] as DateTime,
      duration: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Grove obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.completedAt)
      ..writeByte(2)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
