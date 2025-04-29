import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.jolpi.ca/ergast/f1', // F1 APIのベースURL
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // エラーハンドリング用のインターセプターを追加
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          // エラーハンドリングのロジックをここに追加
          return handler.next(e);
        },
      ),
    );
  }
}
