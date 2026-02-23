import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_listing_model.freezed.dart';
part 'job_listing_model.g.dart';

@freezed
abstract class JobListingModel with _$JobListingModel {
  const factory JobListingModel({
    required String id,
    String? code,
    required String title,
    required String company,
    String? location,
    required String description,
    String? requirements,
    @Default('PRIVATE') String type,
    String? sourceUrl,
    String? applicationUrl,
    String? salary,
    DateTime? deadline,
    String? employerPhone,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JobListingModel;

  factory JobListingModel.fromJson(Map<String, dynamic> json) =>
      _$JobListingModelFromJson(json);
}
