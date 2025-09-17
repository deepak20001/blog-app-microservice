// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileModel {

@JsonKey(name: '_id') String get id; String get username; String get email; String get bio; String get avatar; String get role; bool get isVerified; String get createdAt; String get updatedAt; int get followersCount; int get followingsCount; int get userPostedBlogsCount;
/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<ProfileModel> get copyWith => _$ProfileModelCopyWithImpl<ProfileModel>(this as ProfileModel, _$identity);

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.role, role) || other.role == role)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.followingsCount, followingsCount) || other.followingsCount == followingsCount)&&(identical(other.userPostedBlogsCount, userPostedBlogsCount) || other.userPostedBlogsCount == userPostedBlogsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,bio,avatar,role,isVerified,createdAt,updatedAt,followersCount,followingsCount,userPostedBlogsCount);

@override
String toString() {
  return 'ProfileModel(id: $id, username: $username, email: $email, bio: $bio, avatar: $avatar, role: $role, isVerified: $isVerified, createdAt: $createdAt, updatedAt: $updatedAt, followersCount: $followersCount, followingsCount: $followingsCount, userPostedBlogsCount: $userPostedBlogsCount)';
}


}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res>  {
  factory $ProfileModelCopyWith(ProfileModel value, $Res Function(ProfileModel) _then) = _$ProfileModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String username, String email, String bio, String avatar, String role, bool isVerified, String createdAt, String updatedAt, int followersCount, int followingsCount, int userPostedBlogsCount
});




}
/// @nodoc
class _$ProfileModelCopyWithImpl<$Res>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = null,Object? bio = null,Object? avatar = null,Object? role = null,Object? isVerified = null,Object? createdAt = null,Object? updatedAt = null,Object? followersCount = null,Object? followingsCount = null,Object? userPostedBlogsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,followingsCount: null == followingsCount ? _self.followingsCount : followingsCount // ignore: cast_nullable_to_non_nullable
as int,userPostedBlogsCount: null == userPostedBlogsCount ? _self.userPostedBlogsCount : userPostedBlogsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileModel():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String username,  String email,  String bio,  String avatar,  String role,  bool isVerified,  String createdAt,  String updatedAt,  int followersCount,  int followingsCount,  int userPostedBlogsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.bio,_that.avatar,_that.role,_that.isVerified,_that.createdAt,_that.updatedAt,_that.followersCount,_that.followingsCount,_that.userPostedBlogsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String username,  String email,  String bio,  String avatar,  String role,  bool isVerified,  String createdAt,  String updatedAt,  int followersCount,  int followingsCount,  int userPostedBlogsCount)  $default,) {final _that = this;
switch (_that) {
case _ProfileModel():
return $default(_that.id,_that.username,_that.email,_that.bio,_that.avatar,_that.role,_that.isVerified,_that.createdAt,_that.updatedAt,_that.followersCount,_that.followingsCount,_that.userPostedBlogsCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String username,  String email,  String bio,  String avatar,  String role,  bool isVerified,  String createdAt,  String updatedAt,  int followersCount,  int followingsCount,  int userPostedBlogsCount)?  $default,) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.bio,_that.avatar,_that.role,_that.isVerified,_that.createdAt,_that.updatedAt,_that.followersCount,_that.followingsCount,_that.userPostedBlogsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileModel extends ProfileModel {
  const _ProfileModel({@JsonKey(name: '_id') this.id = '', this.username = 'Anonymous', this.email = '', this.bio = '', this.avatar = '', this.role = '', this.isVerified = false, this.createdAt = '', this.updatedAt = '', this.followersCount = 0, this.followingsCount = 0, this.userPostedBlogsCount = 0}): super._();
  factory _ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override@JsonKey() final  String username;
@override@JsonKey() final  String email;
@override@JsonKey() final  String bio;
@override@JsonKey() final  String avatar;
@override@JsonKey() final  String role;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  String createdAt;
@override@JsonKey() final  String updatedAt;
@override@JsonKey() final  int followersCount;
@override@JsonKey() final  int followingsCount;
@override@JsonKey() final  int userPostedBlogsCount;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileModelCopyWith<_ProfileModel> get copyWith => __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.role, role) || other.role == role)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.followersCount, followersCount) || other.followersCount == followersCount)&&(identical(other.followingsCount, followingsCount) || other.followingsCount == followingsCount)&&(identical(other.userPostedBlogsCount, userPostedBlogsCount) || other.userPostedBlogsCount == userPostedBlogsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,bio,avatar,role,isVerified,createdAt,updatedAt,followersCount,followingsCount,userPostedBlogsCount);

@override
String toString() {
  return 'ProfileModel(id: $id, username: $username, email: $email, bio: $bio, avatar: $avatar, role: $role, isVerified: $isVerified, createdAt: $createdAt, updatedAt: $updatedAt, followersCount: $followersCount, followingsCount: $followingsCount, userPostedBlogsCount: $userPostedBlogsCount)';
}


}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res> implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(_ProfileModel value, $Res Function(_ProfileModel) _then) = __$ProfileModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String username, String email, String bio, String avatar, String role, bool isVerified, String createdAt, String updatedAt, int followersCount, int followingsCount, int userPostedBlogsCount
});




}
/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = null,Object? bio = null,Object? avatar = null,Object? role = null,Object? isVerified = null,Object? createdAt = null,Object? updatedAt = null,Object? followersCount = null,Object? followingsCount = null,Object? userPostedBlogsCount = null,}) {
  return _then(_ProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,followersCount: null == followersCount ? _self.followersCount : followersCount // ignore: cast_nullable_to_non_nullable
as int,followingsCount: null == followingsCount ? _self.followingsCount : followingsCount // ignore: cast_nullable_to_non_nullable
as int,userPostedBlogsCount: null == userPostedBlogsCount ? _self.userPostedBlogsCount : userPostedBlogsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
