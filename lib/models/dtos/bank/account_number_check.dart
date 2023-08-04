import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/entities/shop/bank_entity.dart';

part 'account_number_check.g.dart';

@JsonSerializable()
class AccountNumberCheck {
  String? bin;
  String? accountNumber;

  AccountNumberCheck({this.bin, this.accountNumber});

  AccountNumberCheck copyWith({String? bin, String? accountNumber}) {
    return AccountNumberCheck(
        bin: bin ?? this.bin,
        accountNumber: accountNumber ?? this.accountNumber);
  }

  factory AccountNumberCheck.fromJson(Map<String, dynamic> json) =>
      _$AccountNumberCheckFromJson(json);

  Map<String, dynamic> toJson() => _$AccountNumberCheckToJson(this);
}
