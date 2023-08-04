// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_invoice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvoiceDTO _$CreateInvoiceDTOFromJson(Map<String, dynamic> json) =>
    CreateInvoiceDTO(
      shopId: json['shopId'] as String?,
      cardProducts: (json['cardProducts'] as List<dynamic>?)
          ?.map((e) => CartProductDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProducts: json['totalProducts'] as num?,
      total: json['total'] as num?,
      paymentType: json['paymentType'] as String?,
      issuedDate: json['issuedDate'] as String?,
    );

Map<String, dynamic> _$CreateInvoiceDTOToJson(CreateInvoiceDTO instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'cardProducts': instance.cardProducts,
      'totalProducts': instance.totalProducts,
      'total': instance.total,
      'paymentType': instance.paymentType,
      'issuedDate': instance.issuedDate,
    };
