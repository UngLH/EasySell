// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceEntity _$InvoiceEntityFromJson(Map<String, dynamic> json) =>
    InvoiceEntity(
      id: json['_id'] as String?,
      shopId: json['shopId'] as String?,
      cardProducts: (json['cardProducts'] as List<dynamic>?)
          ?.map((e) => CartProductDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProducts: json['totalProducts'] as num?,
      total: json['total'] as num?,
      paymentType: json['paymentType'] as String?,
      issuedDate: json['issuedDate'] as String?,
    );

Map<String, dynamic> _$InvoiceEntityToJson(InvoiceEntity instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'shopId': instance.shopId,
      'cardProducts': instance.cardProducts,
      'totalProducts': instance.totalProducts,
      'total': instance.total,
      'paymentType': instance.paymentType,
      'issuedDate': instance.issuedDate,
    };
