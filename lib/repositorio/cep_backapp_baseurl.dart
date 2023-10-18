import 'package:dio/dio.dart';
import 'package:dio_back4app_desafio_cep/repositorio/back4app_dio_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CepBack4ppBaseUrl {
  final _dio = Dio();

  Dio get dio => _dio;

  CepBack4ppBaseUrl() {
    _dio.options.baseUrl = dotenv.get("BACK4APP_BASE_URL");
    _dio.interceptors.add(Back4AppDioInterceptor());
  }
}
