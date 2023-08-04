// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_create_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopCreateDTO _$ShopCreateDTOFromJson(Map<String, dynamic> json) =>
    ShopCreateDTO(
      name: json['name'] as String?,
      address: json['address'] as String?,
      userId: json['userId'] as String?,
      bankName: json['bankName'] as String?,
      bankBinCode: json['bankBinCode'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountName: json['accountName'] as String?,
    );

Map<String, dynamic> _$ShopCreateDTOToJson(ShopCreateDTO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'address': instance.address,
      'bankName': instance.bankName,
      'bankBinCode': instance.bankBinCode,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
    };
