// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEntity _$ProductEntityFromJson(Map<String, dynamic> json) =>
    ProductEntity(
      id: json['_id'] as String?,
      shopId: json['shopId'] as String?,
      barcode: json['barcode'] as String?,
      category: json['category'] as String?,
      name: json['name'] as String?,
      amount: json['amount'] as num?,
      unit: json['unit'] as String?,
      manufacturingDate: json['manufacturingDate'] as String?,
      expiredDate: json['expiredDate'] as String?,
      costPrice: json['costPrice'] as int?,
      sellPrice: json['sellPrice'] as int?,
    );

Map<String, dynamic> _$ProductEntityToJson(ProductEntity instance) =>
    <String, dynamic>{
      '_id': instance.id,
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
