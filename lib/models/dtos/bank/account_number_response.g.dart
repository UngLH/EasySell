// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_number_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountNumberResponse _$AccountNumberResponseFromJson(
        Map<String, dynamic> json) =>
    AccountNumberResponse(
      code: json['code'] as String?,
      desc: json['desc'] as String?,
      data: json['data'] == null
          ? null
          : AccountName.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountNumberResponseToJson(
        AccountNumberResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'desc': instance.desc,
      'data': instance.data,
    };

AccountName _$AccountNameFromJson(Map<String, dynamic> json) => AccountName(
      accountName: json['accountName'] as String?,
    );

Map<String, dynamic> _$AccountNameToJson(AccountName instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
    };
