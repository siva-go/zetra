import 'package:flutter_test/flutter_test.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/features/notification/bloc/notification_bloc.dart';
import 'package:zetra/features/notification/bloc/notification_event.dart';
import 'package:zetra/features/notification/bloc/notification_state.dart';
import 'package:zetra/features/notification/models/notification_model.dart';
import 'package:zetra/features/notification/repository/notification_repository.dart';

class FakeNotificationRepository implements NotificationRepository {

  @override
  Future<Result<NotificationsPage>> fetchNotifications({
    int page = 1,
    int pageSize = 20,
    String? category,
    bool? unreadOnly
  }) async {

    return Result<NotificationsPage>.success(
      NotificationsPage(
        data: <NotificationModel>[
          NotificationModel(
            id: 'n1',
            category: category ?? 'CHARGING',
            title: 'Charging started',
            body: 'Your vehicle is charging.',
            createdAt: DateTime(2026, 8, 4, 12, 30)
          )
        ],
        page: 1,
        pageSize: 20,
        total: 1,
        hasMore: false
      )
    );

  }

  @override
  Future<Result<int>> fetchUnreadCount() async {

    return Result<int>.success(1);

  }

  @override
  Future<Result<NotificationModel>> markAsRead(String id) async {

    return Result<NotificationModel>.success(
      NotificationModel(
        id: id,
        category: 'CHARGING',
        title: 'Charging started',
        body: 'Your vehicle is charging.',
        readAt: DateTime.now(),
        createdAt: DateTime(2026, 8, 4, 12, 30)
      )
    );

  }

  @override
  Future<Result<int>> markAllAsRead() async {

    return Result<int>.success(1);

  }

}

void main() {

  late FakeNotificationRepository repository;
  late NotificationBloc bloc;

  setUp(() {

    repository = FakeNotificationRepository();
    bloc = NotificationBloc(repository);

  });

  tearDown(() {

    bloc.close();

  });

  test('NotificationBloc initial state is correct', () {

    expect(bloc.state.status, NotificationStatus.initial);
    expect(bloc.state.notifications, isEmpty);
    expect(bloc.state.unreadCount, 0);

  });

  test('NotificationLoadRequested loads notifications successfully', () async {

    bloc.add(const NotificationLoadRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder(<Matcher>[
        predicate<NotificationState>((NotificationState s) => s.status == NotificationStatus.loading),
        predicate<NotificationState>((NotificationState s) => s.status == NotificationStatus.loaded && s.notifications.length == 1 && s.unreadCount == 1),
      ])
    );

  });

  test('NotificationMarkReadRequested updates item optimistically', () async {

    bloc.add(const NotificationLoadRequested());
    await bloc.stream.firstWhere((NotificationState s) => s.status == NotificationStatus.loaded);

    bloc.add(const NotificationMarkReadRequested('n1'));
    await pumpEventQueue();

    expect(bloc.state.notifications.first.isRead, isTrue);
    expect(bloc.state.unreadCount, 0);

  });

}
