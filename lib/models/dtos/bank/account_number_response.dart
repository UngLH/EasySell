import 'package:json_annotation/json_annotation.dart';

part 'account_number_response.g.dart';

@JsonSerializable()
class AccountNumberResponse {
  String? code;
  String? desc;
  AccountName? data;

  AccountNumberResponse({this.code, this.desc, this.data});

  AccountNumberResponse copyWith(
      {String? code, String? desc, AccountName? data}) {
    return AccountNumberResponse(
        code: code ?? this.code,
        desc: desc ?? this.desc,
        data: data ?? this.data);
  }

  factory AccountNumberResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountNumberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountNumberResponseToJson(this);
}

@JsonSerializable()
class AccountName {
  String? accountName;
  AccountName({this.accountName});

  AccountName copyWith({String? accountName}) {
    return AccountName(accountName: accountName ?? this.accountName);
  }

  factory AccountName.fromJson(Map<String, dynamic> json) =>
      _$AccountNameFromJson(json);

  Map<String, dynamic> toJson() => _$AccountNameToJson(this);
}
