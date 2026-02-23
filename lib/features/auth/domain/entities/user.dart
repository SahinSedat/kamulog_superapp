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
  final String? subscriptionTier;
  final EmploymentType? employmentType;
  final int? ministryCode;
  final String? title;
  final int credits;

  const User({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    this.avatarUrl,
    this.role = 'USER',
    this.isVerified = false,
    this.createdAt,
    this.subscriptionTier,
    this.employmentType,
    this.ministryCode,
    this.title,
    this.credits = 20,
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
    String? subscriptionTier,
    EmploymentType? employmentType,
    int? ministryCode,
    String? title,
    int? credits,
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
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      employmentType: employmentType ?? this.employmentType,
      ministryCode: ministryCode ?? this.ministryCode,
      title: title ?? this.title,
      credits: credits ?? this.credits,
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
    subscriptionTier,
    employmentType,
    ministryCode,
    title,
    credits,
  ];
}
