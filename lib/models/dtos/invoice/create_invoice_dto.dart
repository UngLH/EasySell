import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/enum/payment_type.dart';

import '../../dtos/product/cart_product_dto.dart';

part 'create_invoice_dto.g.dart';

@JsonSerializable()
class CreateInvoiceDTO {
  String? shopId;
  List<CartProductDTO>? cardProducts;
  num? totalProducts;
  num? total;
  String? paymentType;
  String? issuedDate;

  CreateInvoiceDTO(
      {this.shopId,
      this.cardProducts,
      this.totalProducts,
      this.total,
      this.paymentType,
      this.issuedDate});

  CreateInvoiceDTO copyWith(
      {String? shopId,
      List<CartProductDTO>? cardProducts,
      num? totalProducts,
      num? total,
      String? paymentType,
      String? issuedDate}) {
    return CreateInvoiceDTO(
        shopId: shopId ?? this.shopId,
        cardProducts: this.cardProducts,
        totalProducts: totalProducts ?? this.totalProducts,
        total: total ?? this.total,
        paymentType: paymentType ?? this.paymentType,
        issuedDate: issuedDate ?? this.issuedDate);
  }

  factory CreateInvoiceDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateInvoiceDTOFromJson(json);

  Map<String, dynamic> toJson() => {
        'shopId': shopId,
        'cardProducts':
            cardProducts?.map((product) => product.toJson()).toList(),
        'totalProducts': totalProducts,
        'total': total,
        'paymentType': paymentType,
        'issuedDate': issuedDate,
      };
}
