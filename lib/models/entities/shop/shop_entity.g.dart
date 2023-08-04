// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopEntity _$ShopEntityFromJson(Map<String, dynamic> json) => ShopEntity(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      userId: json['userId'] as String?,
      bankName: json['bankName'] as String?,
      bankBinCode: json['bankBinCode'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountName: json['accountName'] as String?,
    );

Map<String, dynamic> _$ShopEntityToJson(ShopEntity instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'address': instance.address,
      'bankName': instance.bankName,
      'bankBinCode': instance.bankBinCode,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
    };
