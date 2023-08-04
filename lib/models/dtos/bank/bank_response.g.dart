// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankResponse _$BankResponseFromJson(Map<String, dynamic> json) => BankResponse(
      code: json['code'] as String?,
      desc: json['desc'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BankEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BankResponseToJson(BankResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'desc': instance.desc,
      'data': instance.data,
    };
