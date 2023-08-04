import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/entities/shop/bank_entity.dart';

part 'shop_create_dto.g.dart';

@JsonSerializable()
class ShopCreateDTO {
  String? userId;
  String? name;
  String? address;
  String? bankName;
  String? bankBinCode;
  String? accountNumber;
  String? accountName;

  ShopCreateDTO(
      {this.name,
      this.address,
      this.userId,
      this.bankName,
      this.bankBinCode,
      this.accountNumber,
      this.accountName});

  ShopCreateDTO copyWith(
      {String? id,
      String? userId,
      String? name,
      String? address,
      String? bankName,
      String? bankBinCode,
      String? accountNumber,
      String? accountName}) {
    return ShopCreateDTO(
        name: name ?? this.name,
        userId: userId ?? this.userId,
        address: address ?? this.address,
        bankName: bankName ?? this.bankName,
        bankBinCode: bankBinCode ?? this.bankBinCode,
        accountNumber: accountNumber ?? this.accountNumber,
        accountName: accountName ?? this.accountName);
  }

  factory ShopCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$ShopCreateDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ShopCreateDTOToJson(this);
}
