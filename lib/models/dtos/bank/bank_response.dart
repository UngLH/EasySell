import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/entities/shop/bank_entity.dart';

part 'bank_response.g.dart';

@JsonSerializable()
class BankResponse {
  String? code;
  String? desc;
  List<BankEntity>? data;

  BankResponse({this.code, this.desc, this.data});

  BankResponse copyWith({
    String? code,
    String? desc,
    List<BankEntity>? data,
  }) {
    return BankResponse(
        code: code ?? this.code,
        desc: desc ?? this.desc,
        data: data ?? this.data);
  }

  factory BankResponse.fromJson(Map<String, dynamic> json) =>
      _$BankResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BankResponseToJson(this);
}
