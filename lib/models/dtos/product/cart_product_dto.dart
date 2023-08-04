import 'package:json_annotation/json_annotation.dart';

part 'cart_product_dto.g.dart';

@JsonSerializable()
class CartProductDTO {
  String? productId;
  String? barcode;
  String? category;
  String? name;
  num amount = 1;
  String? unit;
  String? manufacturingDate;
  String? expiredDate;
  num? sellPrice;

  CartProductDTO(
      {this.barcode,
      this.category,
      this.name,
      required this.amount,
      this.unit,
      this.manufacturingDate,
      this.expiredDate,
      this.sellPrice});

  CartProductDTO copyWith(
      {String? barcode,
      String? category,
      String? name,
      num? amount,
      String? unit,
      String? manufacturingDate,
      String? expiredDate,
      num? sellPrice}) {
    return CartProductDTO(
        barcode: barcode ?? this.barcode,
        category: category ?? this.category,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
        manufacturingDate: manufacturingDate ?? this.manufacturingDate,
        expiredDate: expiredDate ?? this.expiredDate,
        sellPrice: sellPrice ?? this.sellPrice);
  }

  factory CartProductDTO.fromJson(Map<String, dynamic> json) =>
      _$CartProductDTOFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'category': category,
      'name': name,
      'amount': amount,
      'unit': unit,
      'manufacturingDate': manufacturingDate,
      'expiredDate': expiredDate,
      'sellPrice': sellPrice
    };
  }
}
