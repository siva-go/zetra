class NotificationModel {

  final String id;
  final String category; // OFFER, CHARGING, WALLET, PAYMENT, SYSTEM
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final DateTime? readAt;
  final DateTime? expiresAt;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    this.data,
    this.readAt,
    this.expiresAt,
    required this.createdAt
  });

  bool get isRead => readAt != null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? 'SYSTEM',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null,
      readAt: json['readAt'] != null ? DateTime.tryParse(json['readAt'].toString()) : null,
      expiresAt: json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt'].toString()) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now()
    );

  }

  NotificationModel copyWith({String? id, String? category, String? title, String? body, Map<String, dynamic>? data, DateTime? readAt, DateTime? expiresAt, DateTime? createdAt}) {

    return NotificationModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt
    );

  }

}

class NotificationsPage {

  final List<NotificationModel> data;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  const NotificationsPage({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore
  });

  factory NotificationsPage.fromJson(Map<String, dynamic> rawJson) {

    final List<dynamic> rawList = (rawJson.containsKey('data') && rawJson['data'] is List<dynamic>)
        ? rawJson['data'] as List<dynamic> : (rawJson['items'] is List<dynamic> ? rawJson['items'] as List<dynamic> : <dynamic>[]);

    final List<NotificationModel> items = rawList.whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> item) => NotificationModel.fromJson(item))
        .toList();

    final Map<String, dynamic>? pagination = rawJson['pagination'] is Map<String, dynamic>
        ? rawJson['pagination'] as Map<String, dynamic> : (rawJson['meta'] is Map<String, dynamic> ? rawJson['meta'] as Map<String, dynamic> : null);

    final int currentPage = pagination?['page'] is num ? (pagination!['page'] as num).toInt() : 1;
    final int size = pagination?['pageSize'] is num ? (pagination!['pageSize'] as num).toInt() : 20;
    final int tot = pagination?['total'] is num ? (pagination!['total'] as num).toInt() : items.length;
    final int totalPages = pagination?['totalPages'] is num ? (pagination!['totalPages'] as num).toInt() : 1;

    return NotificationsPage(
      data: items,
      page: currentPage,
      pageSize: size,
      total: tot,
      hasMore: currentPage < totalPages
    );

  }

}