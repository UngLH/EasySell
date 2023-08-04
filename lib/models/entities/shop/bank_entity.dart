import 'package:json_annotation/json_annotation.dart';

part 'bank_entity.g.dart';

@JsonSerializable()
class BankEntity {
  int? id;
  String? name;
  String? code;
  String? bin;
  String? shortName;
  String? logo;
  int? transferSupported;
  int? lookupSupported;

  BankEntity({
    this.id,
    this.name,
    this.code,
    this.bin,
    this.shortName,
    this.logo,
    this.transferSupported,
    this.lookupSupported,
  });

  factory BankEntity.fromJson(Map<String, dynamic> json) =>
      _$BankEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BankEntityToJson(this);
}
