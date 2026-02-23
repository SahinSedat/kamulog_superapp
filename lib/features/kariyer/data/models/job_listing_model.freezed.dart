// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_listing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobListingModel {

 String get id; String? get code; String get title; String get company; String? get location; String get description; String? get requirements; String get type; String? get sourceUrl; String? get applicationUrl; String? get salary; DateTime? get deadline; String? get employerPhone; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of JobListingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobListingModelCopyWith<JobListingModel> get copyWith => _$JobListingModelCopyWithImpl<JobListingModel>(this as JobListingModel, _$identity);

  /// Serializes this JobListingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobListingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.type, type) || other.type == type)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.applicationUrl, applicationUrl) || other.applicationUrl == applicationUrl)&&(identical(other.salary, salary) || other.salary == salary)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.employerPhone, employerPhone) || other.employerPhone == employerPhone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,title,company,location,description,requirements,type,sourceUrl,applicationUrl,salary,deadline,employerPhone,createdAt,updatedAt);

@override
String toString() {
  return 'JobListingModel(id: $id, code: $code, title: $title, company: $company, location: $location, description: $description, requirements: $requirements, type: $type, sourceUrl: $sourceUrl, applicationUrl: $applicationUrl, salary: $salary, deadline: $deadline, employerPhone: $employerPhone, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JobListingModelCopyWith<$Res>  {
  factory $JobListingModelCopyWith(JobListingModel value, $Res Function(JobListingModel) _then) = _$JobListingModelCopyWithImpl;
@useResult
$Res call({
 String id, String? code, String title, String company, String? location, String description, String? requirements, String type, String? sourceUrl, String? applicationUrl, String? salary, DateTime? deadline, String? employerPhone, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$JobListingModelCopyWithImpl<$Res>
    implements $JobListingModelCopyWith<$Res> {
  _$JobListingModelCopyWithImpl(this._self, this._then);

  final JobListingModel _self;
  final $Res Function(JobListingModel) _then;

/// Create a copy of JobListingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = freezed,Object? title = null,Object? company = null,Object? location = freezed,Object? description = null,Object? requirements = freezed,Object? type = null,Object? sourceUrl = freezed,Object? applicationUrl = freezed,Object? salary = freezed,Object? deadline = freezed,Object? employerPhone = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requirements: freezed == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,applicationUrl: freezed == applicationUrl ? _self.applicationUrl : applicationUrl // ignore: cast_nullable_to_non_nullable
as String?,salary: freezed == salary ? _self.salary : salary // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,employerPhone: freezed == employerPhone ? _self.employerPhone : employerPhone // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JobListingModel].
extension JobListingModelPatterns on JobListingModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobListingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobListingModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobListingModel value)  $default,){
final _that = this;
switch (_that) {
case _JobListingModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobListingModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobListingModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? code,  String title,  String company,  String? location,  String description,  String? requirements,  String type,  String? sourceUrl,  String? applicationUrl,  String? salary,  DateTime? deadline,  String? employerPhone,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobListingModel() when $default != null:
return $default(_that.id,_that.code,_that.title,_that.company,_that.location,_that.description,_that.requirements,_that.type,_that.sourceUrl,_that.applicationUrl,_that.salary,_that.deadline,_that.employerPhone,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? code,  String title,  String company,  String? location,  String description,  String? requirements,  String type,  String? sourceUrl,  String? applicationUrl,  String? salary,  DateTime? deadline,  String? employerPhone,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JobListingModel():
return $default(_that.id,_that.code,_that.title,_that.company,_that.location,_that.description,_that.requirements,_that.type,_that.sourceUrl,_that.applicationUrl,_that.salary,_that.deadline,_that.employerPhone,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? code,  String title,  String company,  String? location,  String description,  String? requirements,  String type,  String? sourceUrl,  String? applicationUrl,  String? salary,  DateTime? deadline,  String? employerPhone,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobListingModel() when $default != null:
return $default(_that.id,_that.code,_that.title,_that.company,_that.location,_that.description,_that.requirements,_that.type,_that.sourceUrl,_that.applicationUrl,_that.salary,_that.deadline,_that.employerPhone,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobListingModel implements JobListingModel {
  const _JobListingModel({required this.id, this.code, required this.title, required this.company, this.location, required this.description, this.requirements, this.type = 'PRIVATE', this.sourceUrl, this.applicationUrl, this.salary, this.deadline, this.employerPhone, required this.createdAt, required this.updatedAt});
  factory _JobListingModel.fromJson(Map<String, dynamic> json) => _$JobListingModelFromJson(json);

@override final  String id;
@override final  String? code;
@override final  String title;
@override final  String company;
@override final  String? location;
@override final  String description;
@override final  String? requirements;
@override@JsonKey() final  String type;
@override final  String? sourceUrl;
@override final  String? applicationUrl;
@override final  String? salary;
@override final  DateTime? deadline;
@override final  String? employerPhone;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of JobListingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobListingModelCopyWith<_JobListingModel> get copyWith => __$JobListingModelCopyWithImpl<_JobListingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobListingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobListingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.type, type) || other.type == type)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.applicationUrl, applicationUrl) || other.applicationUrl == applicationUrl)&&(identical(other.salary, salary) || other.salary == salary)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.employerPhone, employerPhone) || other.employerPhone == employerPhone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,title,company,location,description,requirements,type,sourceUrl,applicationUrl,salary,deadline,employerPhone,createdAt,updatedAt);

@override
String toString() {
  return 'JobListingModel(id: $id, code: $code, title: $title, company: $company, location: $location, description: $description, requirements: $requirements, type: $type, sourceUrl: $sourceUrl, applicationUrl: $applicationUrl, salary: $salary, deadline: $deadline, employerPhone: $employerPhone, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JobListingModelCopyWith<$Res> implements $JobListingModelCopyWith<$Res> {
  factory _$JobListingModelCopyWith(_JobListingModel value, $Res Function(_JobListingModel) _then) = __$JobListingModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? code, String title, String company, String? location, String description, String? requirements, String type, String? sourceUrl, String? applicationUrl, String? salary, DateTime? deadline, String? employerPhone, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$JobListingModelCopyWithImpl<$Res>
    implements _$JobListingModelCopyWith<$Res> {
  __$JobListingModelCopyWithImpl(this._self, this._then);

  final _JobListingModel _self;
  final $Res Function(_JobListingModel) _then;

/// Create a copy of JobListingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = freezed,Object? title = null,Object? company = null,Object? location = freezed,Object? description = null,Object? requirements = freezed,Object? type = null,Object? sourceUrl = freezed,Object? applicationUrl = freezed,Object? salary = freezed,Object? deadline = freezed,Object? employerPhone = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_JobListingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requirements: freezed == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,applicationUrl: freezed == applicationUrl ? _self.applicationUrl : applicationUrl // ignore: cast_nullable_to_non_nullable
as String?,salary: freezed == salary ? _self.salary : salary // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,employerPhone: freezed == employerPhone ? _self.employerPhone : employerPhone // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
