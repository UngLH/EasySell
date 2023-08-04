import 'package:json_annotation/json_annotation.dart';

part 'shop_entity.g.dart';

@JsonSerializable()
class ShopEntity {
  @JsonKey(name: "_id")
  String? id;
  String? userId;
  String? name;
  String? address;
  String? bankName;
  String? bankBinCode;
  String? accountNumber;
  String? accountName;

  ShopEntity(
      {this.id,
      this.name,
      this.address,
      this.userId,
      this.bankName,
      this.bankBinCode,
      this.accountNumber,
      this.accountName});

  ShopEntity copyWith(
      {String? id,
      String? userId,
      String? name,
      String? address,
      String? bankName,
      String? bankBinCode,
      String? accountNumber,
      String? accountName}) {
    return ShopEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        address: address ?? this.address,
        bankName: bankName ?? this.bankName,
        bankBinCode: bankBinCode ?? this.bankBinCode,
        accountNumber: accountNumber ?? this.accountNumber,
        accountName: accountName ?? this.accountName);
  }

  factory ShopEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopEntityToJson(this);
}
