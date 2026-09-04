import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/core/errors/error_handler.dart';
import 'package:zetra/features/notification/models/notification_model.dart';

class NotificationRepository {

  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  /// Fetch notifications list with pagination & optional filtering
  Future<Result<NotificationsPage>> fetchNotifications({int page = 1, int pageSize = 20, String? category, bool? unreadOnly}) async {

    try {

      final Map<String, dynamic> queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize
      };

      if (category != null && category.isNotEmpty) {

        queryParams['category'] = category;

      }

      if (unreadOnly != null) {

        queryParams['unreadOnly'] = unreadOnly;

      }

      final Response<dynamic> response = await _apiClient.dio.get(
        '/notifications/me',
        queryParameters: queryParams
      );

      debugPrint('DEBUG FETCH NOTIFICATIONS RESPONSE: ${response.data}');

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic> : <String, dynamic>{'data': response.data};

      return Result<NotificationsPage>.success(NotificationsPage.fromJson(data));

    } on Object catch (e) {

      debugPrint('FETCH NOTIFICATIONS ERROR: $e');
      if (e is DioException && e.response?.statusCode == 500) {

        return Result<NotificationsPage>.success(
          const NotificationsPage(
            data: <NotificationModel>[],
            page: 1,
            pageSize: 20,
            total: 0,
            hasMore: false
          )
        );

      }
      return Result<NotificationsPage>.failure(ErrorHandler.handle(e));

    }

  }

  /// Get unread notification count
  Future<Result<int>> fetchUnreadCount() async {

    try {

      final Response<dynamic> response = await _apiClient.dio.get('/notifications/me/unread-count');
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;

      int count = 0;
      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {

        count = (data['data']['unreadCount'] as num?)?.toInt() ?? 0;

      } else {

        count = (data['unreadCount'] as num?)?.toInt() ?? 0;

      }

      return Result<int>.success(count);

    } on Object catch (e) {

      debugPrint('FETCH UNREAD COUNT ERROR: $e');
      // If server returns 500 or fails, fallback to 0 unread count gracefully
      return Result<int>.success(0);

    }

  }

  /// Mark a single notification as read by ID
  Future<Result<NotificationModel>> markAsRead(String id) async {

    try {

      final Response<dynamic> response = await _apiClient.dio.post('/notifications/me/$id/read');
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Map<String, dynamic> notifJson = (data.containsKey('data') && data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic> : data;

      return Result<NotificationModel>.success(NotificationModel.fromJson(notifJson));

    } on Object catch (e) {

      debugPrint('MARK AS READ ERROR: $e');
      return Result<NotificationModel>.failure(ErrorHandler.handle(e));

    }

  }

  /// Mark all notifications as read
  Future<Result<int>> markAllAsRead() async {

    try {

      final Response<dynamic> response = await _apiClient.dio.post('/notifications/me/read-all');
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;

      int updatedCount = 0;

      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {

        updatedCount = (data['data']['updatedCount'] as num?)?.toInt() ?? 0;

      } else {

        updatedCount = (data['updatedCount'] as num?)?.toInt() ?? 0;

      }

      return Result<int>.success(updatedCount);

    } on Object catch (e) {

      debugPrint('MARK ALL AS READ ERROR: $e');
      return Result<int>.failure(ErrorHandler.handle(e));

    }

  }

}