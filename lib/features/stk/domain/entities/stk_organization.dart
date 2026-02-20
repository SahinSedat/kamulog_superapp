import 'package:equatable/equatable.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

class StkOrganization extends Equatable {
  final String id;
  final String name;
  final StkType type;
  final String? description;
  final String? logoUrl;
  final String? city;
  final int memberCount;
  final bool isVerified;
  final DateTime? createdAt;

  const StkOrganization({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.logoUrl,
    this.city,
    this.memberCount = 0,
    this.isVerified = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, type, city, memberCount, isVerified];
}
