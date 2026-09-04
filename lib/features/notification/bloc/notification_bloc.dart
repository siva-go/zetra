import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/features/notification/bloc/notification_event.dart';
import 'package:zetra/features/notification/bloc/notification_state.dart';
import 'package:zetra/features/notification/models/notification_model.dart';
import 'package:zetra/features/notification/repository/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {

  final NotificationRepository _repository;

  NotificationBloc(this._repository) : super(NotificationState.initial()) {

    on<NotificationInitialized>((NotificationInitialized event, Emitter<NotificationState> emit) {
      add(const NotificationLoadRequested());
    });
    on<NotificationLoadRequested>(_onLoadRequested);
    on<NotificationLoadMoreRequested>(_onLoadMoreRequested);
    on<NotificationMarkReadRequested>(_onMarkReadRequested);
    on<NotificationMarkAllReadRequested>(_onMarkAllReadRequested);
    on<NotificationCategorySelected>(_onCategorySelected);
    on<NotificationFilterUnreadToggled>(_onUnreadFilterToggled);

  }

  Future<void> _onLoadRequested(NotificationLoadRequested event, Emitter<NotificationState> emit) async {

    final String? cat = event.category ?? state.selectedCategory;
    final bool? unreadFilter = event.unreadOnly ?? state.unreadOnlyFilter;

    emit(state.copyWith(
      status: NotificationStatus.loading,
      clearError: true,
      selectedCategory: cat,
      unreadOnlyFilter: unreadFilter
    ));

    final Result<NotificationsPage> notifsRes = await _repository.fetchNotifications(
      category: cat,
      unreadOnly: unreadFilter
    );

    final Result<int> countRes = await _repository.fetchUnreadCount();

    final int unread = countRes.isSuccess ? countRes.dataOrNull! : state.unreadCount;

    if (notifsRes.isSuccess) {

      final NotificationsPage page = notifsRes.dataOrNull!;
      emit(state.copyWith(
        status: NotificationStatus.loaded,
        notifications: page.data,
        unreadCount: unread,
        page: 1,
        hasMore: page.hasMore
      ));

    } else {

      emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: notifsRes.failureOrNull?.toString() ?? 'Failed to load notifications'
      ));

    }

  }

  Future<void> _onLoadMoreRequested(NotificationLoadMoreRequested event, Emitter<NotificationState> emit) async {

    if (!state.hasMore || state.isLoadingMore) {

      return;

    }

    emit(state.copyWith(
      isLoadingMore: true
    ));

    final int nextPage = state.page + 1;
    final Result<NotificationsPage> res = await _repository.fetchNotifications(
      page: nextPage,
      category: state.selectedCategory,
      unreadOnly: state.unreadOnlyFilter
    );

    if (res.isSuccess) {

      final NotificationsPage page = res.dataOrNull!;
      emit(state.copyWith(
        notifications: <NotificationModel>[...state.notifications, ...page.data],
        page: nextPage,
        hasMore: page.hasMore,
        isLoadingMore: false
      ));

    } else {

      emit(state.copyWith(
        isLoadingMore: false
      ));

    }

  }

  Future<void> _onMarkReadRequested(NotificationMarkReadRequested event, Emitter<NotificationState> emit) async {

    // Optimistically update
    final List<NotificationModel> updatedList = state.notifications.map((NotificationModel item) {

      if (item.id == event.id) {

        return item.copyWith(
            readAt: DateTime.now()
        );

      }

      return item;

    }).toList();

    final int newUnreadCount = (state.unreadCount - 1).clamp(0, 999);

    emit(state.copyWith(
      notifications: updatedList,
      unreadCount: newUnreadCount
    ));

    final Result<NotificationModel> res = await _repository.markAsRead(event.id);

    if (!res.isSuccess) {

      // Revert if API call fails
      add(const NotificationLoadRequested());

    }

  }

  Future<void> _onMarkAllAllRead(Emitter<NotificationState> emit) async {

    final List<NotificationModel> updatedList = state.notifications.map((NotificationModel item) {
      return item.copyWith(readAt: DateTime.now());
    }).toList();

    emit(state.copyWith(
      notifications: updatedList,
      unreadCount: 0
    ));

    final Result<int> res = await _repository.markAllAsRead();

    if (!res.isSuccess) {

      add(const NotificationLoadRequested());

    }

  }

  Future<void> _onMarkAllReadRequested(NotificationMarkAllReadRequested event, Emitter<NotificationState> emit) async {

    await _onMarkAllAllRead(emit);

  }

  void _onCategorySelected(NotificationCategorySelected event, Emitter<NotificationState> emit) {

    final String? cat = event.category;

    if (cat == state.selectedCategory) {

      return;

    }

    add(NotificationLoadRequested(
        category: cat
    ));

  }

  void _onUnreadFilterToggled(NotificationFilterUnreadToggled event, Emitter<NotificationState> emit) {

    add(NotificationLoadRequested(
        unreadOnly: event.unreadOnly
    ));

  }

}