import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/enum/payment_type.dart';

import '../../dtos/product/cart_product_dto.dart';

part 'invoice_entity.g.dart';

@JsonSerializable()
class InvoiceEntity {
  @JsonKey(name: "_id")
  String? id;
  String? shopId;
  List<CartProductDTO>? cardProducts;
  num? totalProducts;
  num? total;
  String? paymentType;
  String? issuedDate;

  InvoiceEntity(
      {this.id,
      this.shopId,
      this.cardProducts,
      this.totalProducts,
      this.total,
      this.paymentType,
      this.issuedDate});

  InvoiceEntity copyWith(
      {String? id,
      String? shopId,
      List<CartProductDTO>? cardProducts,
      num? totalProducts,
      num? total,
      String? paymentType,
      String? issuedDate}) {
    return InvoiceEntity(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        cardProducts: this.cardProducts,
        totalProducts: totalProducts ?? this.totalProducts,
        total: total ?? this.total,
        paymentType: paymentType ?? this.paymentType,
        issuedDate: issuedDate ?? this.issuedDate);
  }

  factory InvoiceEntity.fromJson(Map<String, dynamic> json) =>
      _$InvoiceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceEntityToJson(this);
}
