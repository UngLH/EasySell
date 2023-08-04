// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProductDTO _$CreateProductDTOFromJson(Map<String, dynamic> json) =>
    CreateProductDTO(
      shopId: json['shopId'] as String?,
      barcode: json['barcode'] as String?,
      category: json['category'] as String?,
      name: json['name'] as String?,
      amount: json['amount'] as num?,
      unit: json['unit'] as String?,
      manufacturingDate: json['manufacturingDate'] as String?,
      expiredDate: json['expiredDate'] as String?,
      costPrice: json['costPrice'] as num?,
      sellPrice: json['sellPrice'] as num?,
    );

Map<String, dynamic> _$CreateProductDTOToJson(CreateProductDTO instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'barcode': instance.barcode,
      'category': instance.category,
      'name': instance.name,
      'amount': instance.amount,
      'unit': instance.unit,
      'manufacturingDate': instance.manufacturingDate,
      'expiredDate': instance.expiredDate,
      'costPrice': instance.costPrice,
      'sellPrice': instance.sellPrice,
    };
