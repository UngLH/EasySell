// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankEntity _$BankEntityFromJson(Map<String, dynamic> json) => BankEntity(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      bin: json['bin'] as String?,
      shortName: json['shortName'] as String?,
      logo: json['logo'] as String?,
      transferSupported: json['transferSupported'] as int?,
      lookupSupported: json['lookupSupported'] as int?,
    );

Map<String, dynamic> _$BankEntityToJson(BankEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'bin': instance.bin,
      'shortName': instance.shortName,
      'logo': instance.logo,
      'transferSupported': instance.transferSupported,
      'lookupSupported': instance.lookupSupported,
    };
