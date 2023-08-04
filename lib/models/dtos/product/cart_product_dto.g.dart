// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProductDTO _$CartProductDTOFromJson(Map<String, dynamic> json) =>
    CartProductDTO(
      barcode: json['barcode'] as String?,
      category: json['category'] as String?,
      name: json['name'] as String?,
      amount: json['amount'] as num,
      unit: json['unit'] as String?,
      manufacturingDate: json['manufacturingDate'] as String?,
      expiredDate: json['expiredDate'] as String?,
      sellPrice: json['sellPrice'] as num?,
    )..productId = json['productId'] as String?;

Map<String, dynamic> _$CartProductDTOToJson(CartProductDTO instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'barcode': instance.barcode,
      'category': instance.category,
      'name': instance.name,
      'amount': instance.amount,
      'unit': instance.unit,
      'manufacturingDate': instance.manufacturingDate,
      'expiredDate': instance.expiredDate,
      'sellPrice': instance.sellPrice,
    };
