import 'package:flutter/foundation.dart';
import 'package:zetra/features/notification/models/notification_model.dart';

enum NotificationStatus { initial, loading, loaded, error }

@immutable
class NotificationState {

  final NotificationStatus status;
  final List<NotificationModel> notifications;
  final int unreadCount;
  final String? selectedCategory;
  final bool? unreadOnlyFilter;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const NotificationState({
    required this.status,
    required this.notifications,
    required this.unreadCount,
    this.selectedCategory,
    this.unreadOnlyFilter,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
    this.errorMessage
  });

  factory NotificationState.initial() {

    return const NotificationState(
      status: NotificationStatus.initial,
      notifications: <NotificationModel>[],
      unreadCount: 0,
      page: 1,
      hasMore: false,
      isLoadingMore: false
    );

  }

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notifications,
    int? unreadCount,
    String? selectedCategory,
    bool clearCategory = false,
    bool? unreadOnlyFilter,
    bool clearUnreadOnlyFilter = false,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false
  }) {

    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      unreadOnlyFilter: clearUnreadOnlyFilter ? null : (unreadOnlyFilter ?? this.unreadOnlyFilter),
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage)
    );

  }

}