import 'package:equatable/equatable.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

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
  final EmploymentType? employmentType;
  final int? ministryCode;
  final String? title;

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
    this.employmentType,
    this.ministryCode,
    this.title,
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
    EmploymentType? employmentType,
    int? ministryCode,
    String? title,
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
      employmentType: employmentType ?? this.employmentType,
      ministryCode: ministryCode ?? this.ministryCode,
      title: title ?? this.title,
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
    employmentType,
    ministryCode,
    title,
  ];
}
