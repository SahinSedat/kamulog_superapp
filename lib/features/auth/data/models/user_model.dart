import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.phone,
    super.name,
    super.email,
    super.avatarUrl,
    super.role,
    super.isVerified,
    super.createdAt,
    super.subscriptionTier,
    super.employmentType,
    super.ministryCode,
    super.title,
    super.credits = 20,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['image'] as String? ?? json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'USER',
      isVerified: json['emailVerified'] != null,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'] as String)
              : null,
      subscriptionTier: json['subscriptionTier'] as String?,
      employmentType: _parseEmploymentType(json['employmentType']),
      ministryCode: json['ministryCode'] as int?,
      title: json['title'] as String?,
      credits: json['credits'] as int? ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
      'emailVerified': isVerified ? DateTime.now().toIso8601String() : null,
      'createdAt': createdAt?.toIso8601String(),
      'subscriptionTier': subscriptionTier,
      'employmentType': employmentType?.name,
      'ministryCode': ministryCode,
      'title': title,
      'credits': credits,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phone: user.phone,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      role: user.role,
      isVerified: user.isVerified,
      createdAt: user.createdAt,
      subscriptionTier: user.subscriptionTier,
      employmentType: user.employmentType,
      ministryCode: user.ministryCode,
      title: user.title,
      credits: user.credits,
    );
  }

  @override
  User copyWith({
    String? id,
    String? phone,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
    bool? isVerified,
    DateTime? createdAt,
    String? subscriptionTier,
    EmploymentType? employmentType,
    int? ministryCode,
    String? title,
    int? credits,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      employmentType: employmentType ?? this.employmentType,
      ministryCode: ministryCode ?? this.ministryCode,
      title: title ?? this.title,
      credits: credits ?? this.credits,
    );
  }

  static EmploymentType? _parseEmploymentType(dynamic value) {
    if (value == null) return null;
    if (value is EmploymentType) return value;
    if (value is String) {
      return EmploymentType.values.where((e) => e.name == value).firstOrNull;
    }
    if (value is int && value < EmploymentType.values.length) {
      return EmploymentType.values[value];
    }
    return null;
  }
}
