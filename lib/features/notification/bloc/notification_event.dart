import 'package:flutter/foundation.dart';

@immutable
abstract class NotificationEvent {

  const NotificationEvent();

}

class NotificationInitialized extends NotificationEvent {

  const NotificationInitialized();

}

class NotificationLoadRequested extends NotificationEvent {

  final String? category;
  final bool? unreadOnly;

  const NotificationLoadRequested({this.category, this.unreadOnly});

}

class NotificationLoadMoreRequested extends NotificationEvent {

  const NotificationLoadMoreRequested();

}

class NotificationMarkReadRequested extends NotificationEvent {

  final String id;

  const NotificationMarkReadRequested(this.id);

}

class NotificationMarkAllReadRequested extends NotificationEvent {

  const NotificationMarkAllReadRequested();

}

class NotificationCategorySelected extends NotificationEvent {

  final String? category;

  const NotificationCategorySelected(this.category);

}

class NotificationFilterUnreadToggled extends NotificationEvent {

  final bool? unreadOnly;

  const NotificationFilterUnreadToggled(this.unreadOnly);

}