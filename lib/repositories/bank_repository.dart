import 'package:mobile/configs/app_configs.dart';
import 'package:mobile/models/dtos/bank/account_number_check.dart';
import 'package:mobile/models/dtos/bank/account_number_response.dart';
import 'package:mobile/models/dtos/bank/bank_response.dart';
import 'package:mobile/models/entities/shop/bank_entity.dart';
import 'package:mobile/networks/api_vietqr.dart';

abstract class BankRepository {
  Future<BankResponse> getListBanks();
  Future<AccountNumberResponse> checkAccountNumber(AccountNumberCheck body);
}

class BankRepositoryImpl extends BankRepository {
  ApiVietQRBank? _apiVietQRBank;

  BankRepositoryImpl(ApiVietQRBank? client) {
    _apiVietQRBank = client;
  }

  @override
  Future<BankResponse> getListBanks() async {
    return _apiVietQRBank!.getListBanks();
  }

  @override
  Future<AccountNumberResponse> checkAccountNumber(
      AccountNumberCheck accountNumberCheck) {
    const xClientId = AppConfig.vietQRClientId;
    const xApiId = AppConfig.vietQRApiKey;
    final body = {
      "bin": accountNumberCheck.bin,
      "accountNumber": accountNumberCheck.accountNumber
    };
    return _apiVietQRBank!.checkAccountNumber(xClientId, xApiId, body);
  }
}
