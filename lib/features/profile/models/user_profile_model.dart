import 'package:flutter/foundation.dart';

@immutable
class UserProfileModel {

  final String id;
  final String? email;
  final String? phone;
  final String? fullName;
  final String role;
  final String status;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? organizationId;
  final String? organizationMemberRole;
  final List<String> organizationIds;

  const UserProfileModel({
    required this.id,
    this.email,
    this.phone,
    this.fullName,
    this.role = 'DRIVER',
    this.status = 'ACTIVE',
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.organizationId,
    this.organizationMemberRole,
    this.organizationIds = const <String>[]
  });

  String get initials {

    if (fullName != null && fullName!.trim().isNotEmpty) {

      final List<String> parts = fullName!.trim().split(RegExp(r'\s+'));

      if (parts.length >= 2) {

        return '${parts.first[0]}${parts[1][0]}'.toUpperCase();

      } else if (parts.isNotEmpty && parts.first.isNotEmpty) {

        return parts.first[0].toUpperCase();

      }

    }

    if (email != null && email!.isNotEmpty) {

      return email![0].toUpperCase();

    }

    return 'Z';

  }

  String get displayName {

    if (fullName != null && fullName!.trim().isNotEmpty) {

      return fullName!.trim();

    }

    if (email != null && email!.isNotEmpty) {

      return email!.split('@').first;

    }

    if (phone != null && phone!.isNotEmpty) {

      return phone!;

    }

    return 'Driver';

  }

  String get formattedJoinedDate {

    if (createdAt == null) {

      return '';

    }

    final List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final String month = months[createdAt!.month - 1];
    return 'Member since $month ${createdAt!.year}';

  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {

    DateTime? parseDate(dynamic value) {

      if (value == null) {

        return null;

      }

      return DateTime.tryParse(value.toString());

    }

    final List<dynamic>? rawOrgIds = json['organizationIds'] as List<dynamic>?;
    final List<String> orgIds = rawOrgIds != null ? rawOrgIds.map((dynamic e) => e.toString()).toList() : <String>[];

    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      fullName: json['fullName']?.toString(),
      role: json['role']?.toString() ?? 'DRIVER',
      status: json['status']?.toString() ?? 'ACTIVE',
      emailVerifiedAt: parseDate(json['emailVerifiedAt']),
      phoneVerifiedAt: parseDate(json['phoneVerifiedAt']),
      lastLoginAt: parseDate(json['lastLoginAt']),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      organizationId: json['organizationId']?.toString(),
      organizationMemberRole: json['organizationMemberRole']?.toString(),
      organizationIds: orgIds
    );

  }

  Map<String, dynamic> toJson() {

    return <String, dynamic>{
      'id': id,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'role': role,
      'status': status,
      'emailVerifiedAt': emailVerifiedAt?.toIso8601String(),
      'phoneVerifiedAt': phoneVerifiedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'organizationId': organizationId,
      'organizationMemberRole': organizationMemberRole,
      'organizationIds': organizationIds
    };

  }

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? fullName,
    String? role,
    String? status,
    DateTime? emailVerifiedAt,
    DateTime? phoneVerifiedAt,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? organizationId,
    String? organizationMemberRole,
    List<String>? organizationIds
  }) {

    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      status: status ?? this.status,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      organizationId: organizationId ?? this.organizationId,
      organizationMemberRole: organizationMemberRole ?? this.organizationMemberRole,
      organizationIds: organizationIds ?? this.organizationIds
    );

  }

}