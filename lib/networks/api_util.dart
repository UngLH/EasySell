import 'package:dio/dio.dart';
import 'package:mobile/configs/app_configs.dart';
import 'package:mobile/networks/api_vietqr.dart';
import 'api_interceptors.dart';

class ApiUtil {
  static ApiVietQRBank? getApiVietQR() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.interceptors.add(ApiInterceptors());
    final apiVietQR = ApiVietQRBank(dio, baseUrl: AppConfig.vietQRBanks);
    return apiVietQR;
  }
}
