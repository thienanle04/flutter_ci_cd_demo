import 'package:dio/dio.dart';

final class DioClient {
  static Dio create({required String baseUrl, required String apiKey}) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: <String, Object?>{'Accept': 'application/json'},
      queryParameters: <String, Object?>{
        // OpenWeatherMap uses `appid` for API key
        if (apiKey.trim().isNotEmpty) 'appid': apiKey.trim(),
        // default to metric for demo clarity
        'units': 'metric',
      },
    );

    final dio = Dio(options);
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
        error: true,
      ),
    );
    return dio;
  }
}
