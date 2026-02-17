import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phone;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final String role;
  final bool isVerified;
  final DateTime? createdAt;
  final int credits;
  final String? subscriptionTier;

  const User({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    this.avatarUrl,
    this.role = 'USER',
    this.isVerified = false,
    this.createdAt,
    this.credits = 0,
    this.subscriptionTier,
  });

  User copyWith({
    String? id,
    String? phone,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
    bool? isVerified,
    DateTime? createdAt,
    int? credits,
    String? subscriptionTier,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      credits: credits ?? this.credits,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
    );
  }

  @override
  List<Object?> get props => [
    id,
    phone,
    name,
    email,
    avatarUrl,
    role,
    isVerified,
    createdAt,
    credits,
    subscriptionTier,
  ];
}
