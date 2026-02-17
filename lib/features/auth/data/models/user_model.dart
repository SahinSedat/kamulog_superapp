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
    super.credits,
    super.subscriptionTier,
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
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      credits: json['credits'] as int? ?? 0,
      subscriptionTier: json['subscriptionTier'] as String?,
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
      'credits': credits,
      'subscriptionTier': subscriptionTier,
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
      credits: user.credits,
      subscriptionTier: user.subscriptionTier,
    );
  }
}
