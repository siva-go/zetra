import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zetra/core/errors/error_handler.dart';
import 'package:zetra/core/errors/failure.dart';

void main() {
  group('ErrorHandler.handle', () {
    test('maps DioExceptionType.connectionError to NetworkFailure', () {
      final DioException dio = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(),
      );
      expect(ErrorHandler.handle(dio), isA<NetworkFailure>());
    });

    test('maps DioExceptionType.connectionTimeout to TimeoutFailure', () {
      final DioException dio = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      );
      expect(ErrorHandler.handle(dio), isA<TimeoutFailure>());
    });

    test('maps 401 HTTP to UnauthorizedFailure', () {
      final DioException dio = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 401,
        ),
      );
      expect(ErrorHandler.handle(dio), isA<UnauthorizedFailure>());
    });

    test('maps 404 HTTP to NotFoundFailure', () {
      final DioException dio = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 404,
        ),
      );
      expect(ErrorHandler.handle(dio), isA<NotFoundFailure>());
    });

    test('maps 500 HTTP to ServerFailure', () {
      final DioException dio = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 500,
        ),
      );
      final Failure result = ErrorHandler.handle(dio);
      expect(result, isA<ServerFailure>());
      expect((result as ServerFailure).code, 500);
    });

    test('maps unknown error to UnknownFailure', () {
      expect(ErrorHandler.handle(Exception('unknown')), isA<UnknownFailure>());
    });
  });
}
