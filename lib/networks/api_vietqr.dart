import 'package:dio/dio.dart';
import 'package:mobile/configs/app_configs.dart';
import 'package:mobile/models/dtos/bank/account_number_response.dart';
import 'package:mobile/models/dtos/bank/bank_response.dart';
import 'package:mobile/models/entities/shop/bank_entity.dart';
import 'package:retrofit/retrofit.dart';

part 'api_vietqr.g.dart';

@RestApi(baseUrl: AppConfig.vietQRBanks)
abstract class ApiVietQRBank {
  factory ApiVietQRBank(Dio dio, {String baseUrl}) = _ApiVietQRBank;

  @GET("/banks")
  Future<BankResponse> getListBanks();

  @POST("/lookup")
  Future<AccountNumberResponse> checkAccountNumber(
      @Header('x-client-id') String xClientId,
      @Header('x-api-key') String xApiId,
      @Body() Map<String, dynamic> body);
}
