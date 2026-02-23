// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobListingModel _$JobListingModelFromJson(Map<String, dynamic> json) =>
    _JobListingModel(
      id: json['id'] as String,
      code: json['code'] as String?,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String?,
      description: json['description'] as String,
      requirements: json['requirements'] as String?,
      type: json['type'] as String? ?? 'PRIVATE',
      sourceUrl: json['sourceUrl'] as String?,
      applicationUrl: json['applicationUrl'] as String?,
      salary: json['salary'] as String?,
      deadline:
          json['deadline'] == null
              ? null
              : DateTime.parse(json['deadline'] as String),
      employerPhone: json['employerPhone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$JobListingModelToJson(_JobListingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'title': instance.title,
      'company': instance.company,
      'location': instance.location,
      'description': instance.description,
      'requirements': instance.requirements,
      'type': instance.type,
      'sourceUrl': instance.sourceUrl,
      'applicationUrl': instance.applicationUrl,
      'salary': instance.salary,
      'deadline': instance.deadline?.toIso8601String(),
      'employerPhone': instance.employerPhone,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
