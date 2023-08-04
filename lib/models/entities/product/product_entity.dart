import 'package:json_annotation/json_annotation.dart';

part 'product_entity.g.dart';

@JsonSerializable()
class ProductEntity {
  @JsonKey(name: "_id")
  String? id;
  String? shopId;
  String? barcode;
  String? category;
  String? name;
  num? amount;
  String? unit;
  String? manufacturingDate;
  String? expiredDate;
  int? costPrice;
  int? sellPrice;

  ProductEntity(
      {this.id,
      this.shopId,
      this.barcode,
      this.category,
      this.name,
      this.amount,
      this.unit,
      this.manufacturingDate,
      this.expiredDate,
      this.costPrice,
      this.sellPrice});

  ProductEntity copyWith(
      {String? id,
      String? shopId,
      String? barcode,
      String? category,
      String? name,
      num? amount,
      String? unit,
      String? manufacturingDate,
      String? expiredDate,
      int? costPrice,
      int? sellPrice}) {
    return ProductEntity(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        barcode: barcode ?? this.barcode,
        category: category ?? this.category,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
        manufacturingDate: manufacturingDate ?? this.manufacturingDate,
        expiredDate: expiredDate ?? this.expiredDate,
        costPrice: costPrice ?? this.costPrice,
        sellPrice: sellPrice ?? this.sellPrice);
  }

  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProductEntityToJson(this);
}
