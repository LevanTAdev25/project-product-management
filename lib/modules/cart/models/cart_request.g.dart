// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartRequestAdapter extends TypeAdapter<CartRequest> {
  @override
  final int typeId = 2;

  @override
  CartRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartRequest(
      id: fields[0] as int,
      name: fields[1] as String,
      code: fields[2] as String,
      price: fields[3] as double,
      stock: fields[4] as int,
      category: fields[5] as CategoryResponse,
      description: fields[6] as String,
      image: fields[7] as String,
      quantity: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartRequest obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.stock)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
