import 'package:json_annotation/json_annotation.dart';

part 'create_product_dto.g.dart';

@JsonSerializable()
class CreateProductDTO {
  String? shopId;
  String? barcode;
  String? category;
  String? name;
  num? amount;
  String? unit;
  String? manufacturingDate;
  String? expiredDate;
  num? costPrice;
  num? sellPrice;

  CreateProductDTO(
      {this.shopId,
      this.barcode,
      this.category,
      this.name,
      this.amount,
      this.unit,
      this.manufacturingDate,
      this.expiredDate,
      this.costPrice,
      this.sellPrice});

  CreateProductDTO copyWith(
      {String? shopId,
      String? barcode,
      String? category,
      String? name,
      num? amount,
      String? unit,
      String? manufacturingDate,
      String? expiredDate,
      num? costPrice,
      num? sellPrice}) {
    return CreateProductDTO(
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

  factory CreateProductDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateProductDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProductDTOToJson(this);
}
