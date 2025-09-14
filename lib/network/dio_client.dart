import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

Dio createDioClient() {
  final dio = Dio(BaseOptions(baseUrl: 'https://local.mock'));
  dio.interceptors.add(LocalMockInterceptor());
  return dio;
}

class LocalMockInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('/api/businesses')) {
      try {
        // simulate latency
        await Future.delayed(const Duration(milliseconds: 500));
        final text = await rootBundle.loadString('assets/businesses.json');
        final data = jsonDecode(text);

        // occasional simulated failure if query param ?fail=true is present
        if (options.queryParameters['simulateFail'] == true ||
            options.queryParameters['fail'] == 'true') {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Simulated network failure',
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 500,
                data: {'message': 'simulated failure'},
              ),
            ),
          );
        }

        final response = Response(
          requestOptions: options,
          statusCode: 200,
          data: data,
        );
        return handler.resolve(response);
      } catch (e, st) {
        return handler.reject(
          DioException(requestOptions: options, error: e, stackTrace: st),
        );
      }
    }
    return handler.next(options);
  }
}
