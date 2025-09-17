// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follower_following_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowerFollowingModel {

@JsonKey(name: '_id') String get id;@JsonKey(name: 'follower') ProfileModel get follower;@JsonKey(name: 'following') ProfileModel get following;@JsonKey(name: 'isFollowing') bool get isFollowing;
/// Create a copy of FollowerFollowingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowerFollowingModelCopyWith<FollowerFollowingModel> get copyWith => _$FollowerFollowingModelCopyWithImpl<FollowerFollowingModel>(this as FollowerFollowingModel, _$identity);

  /// Serializes this FollowerFollowingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowerFollowingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.follower, follower) || other.follower == follower)&&(identical(other.following, following) || other.following == following)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,follower,following,isFollowing);

@override
String toString() {
  return 'FollowerFollowingModel(id: $id, follower: $follower, following: $following, isFollowing: $isFollowing)';
}


}

/// @nodoc
abstract mixin class $FollowerFollowingModelCopyWith<$Res>  {
  factory $FollowerFollowingModelCopyWith(FollowerFollowingModel value, $Res Function(FollowerFollowingModel) _then) = _$FollowerFollowingModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id,@JsonKey(name: 'follower') ProfileModel follower,@JsonKey(name: 'following') ProfileModel following,@JsonKey(name: 'isFollowing') bool isFollowing
});


$ProfileModelCopyWith<$Res> get follower;$ProfileModelCopyWith<$Res> get following;

}
/// @nodoc
class _$FollowerFollowingModelCopyWithImpl<$Res>
    implements $FollowerFollowingModelCopyWith<$Res> {
  _$FollowerFollowingModelCopyWithImpl(this._self, this._then);

  final FollowerFollowingModel _self;
  final $Res Function(FollowerFollowingModel) _then;

/// Create a copy of FollowerFollowingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? follower = null,Object? following = null,Object? isFollowing = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,follower: null == follower ? _self.follower : follower // ignore: cast_nullable_to_non_nullable
as ProfileModel,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as ProfileModel,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FollowerFollowingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<$Res> get follower {
  
  return $ProfileModelCopyWith<$Res>(_self.follower, (value) {
    return _then(_self.copyWith(follower: value));
  });
}/// Create a copy of FollowerFollowingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<$Res> get following {
  
  return $ProfileModelCopyWith<$Res>(_self.following, (value) {
    return _then(_self.copyWith(following: value));
  });
}
}


/// Adds pattern-matching-related methods to [FollowerFollowingModel].
extension FollowerFollowingModelPatterns on FollowerFollowingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowerFollowingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowerFollowingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowerFollowingModel value)  $default,){
final _that = this;
switch (_that) {
case _FollowerFollowingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowerFollowingModel value)?  $default,){
final _that = this;
switch (_that) {
case _FollowerFollowingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id, @JsonKey(name: 'follower')  ProfileModel follower, @JsonKey(name: 'following')  ProfileModel following, @JsonKey(name: 'isFollowing')  bool isFollowing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowerFollowingModel() when $default != null:
return $default(_that.id,_that.follower,_that.following,_that.isFollowing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id, @JsonKey(name: 'follower')  ProfileModel follower, @JsonKey(name: 'following')  ProfileModel following, @JsonKey(name: 'isFollowing')  bool isFollowing)  $default,) {final _that = this;
switch (_that) {
case _FollowerFollowingModel():
return $default(_that.id,_that.follower,_that.following,_that.isFollowing);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id, @JsonKey(name: 'follower')  ProfileModel follower, @JsonKey(name: 'following')  ProfileModel following, @JsonKey(name: 'isFollowing')  bool isFollowing)?  $default,) {final _that = this;
switch (_that) {
case _FollowerFollowingModel() when $default != null:
return $default(_that.id,_that.follower,_that.following,_that.isFollowing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowerFollowingModel extends FollowerFollowingModel {
  const _FollowerFollowingModel({@JsonKey(name: '_id') this.id = '', @JsonKey(name: 'follower') this.follower = const ProfileModel(), @JsonKey(name: 'following') this.following = const ProfileModel(), @JsonKey(name: 'isFollowing') this.isFollowing = false}): super._();
  factory _FollowerFollowingModel.fromJson(Map<String, dynamic> json) => _$FollowerFollowingModelFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override@JsonKey(name: 'follower') final  ProfileModel follower;
@override@JsonKey(name: 'following') final  ProfileModel following;
@override@JsonKey(name: 'isFollowing') final  bool isFollowing;

/// Create a copy of FollowerFollowingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowerFollowingModelCopyWith<_FollowerFollowingModel> get copyWith => __$FollowerFollowingModelCopyWithImpl<_FollowerFollowingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowerFollowingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowerFollowingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.follower, follower) || other.follower == follower)&&(identical(other.following, following) || other.following == following)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,follower,following,isFollowing);

@override
String toString() {
  return 'FollowerFollowingModel(id: $id, follower: $follower, following: $following, isFollowing: $isFollowing)';
}


}

/// @nodoc
abstract mixin class _$FollowerFollowingModelCopyWith<$Res> implements $FollowerFollowingModelCopyWith<$Res> {
  factory _$FollowerFollowingModelCopyWith(_FollowerFollowingModel value, $Res Function(_FollowerFollowingModel) _then) = __$FollowerFollowingModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id,@JsonKey(name: 'follower') ProfileModel follower,@JsonKey(name: 'following') ProfileModel following,@JsonKey(name: 'isFollowing') bool isFollowing
});


@override $ProfileModelCopyWith<$Res> get follower;@override $ProfileModelCopyWith<$Res> get following;

}
/// @nodoc
class __$FollowerFollowingModelCopyWithImpl<$Res>
    implements _$FollowerFollowingModelCopyWith<$Res> {
  __$FollowerFollowingModelCopyWithImpl(this._self, this._then);

  final _FollowerFollowingModel _self;
  final $Res Function(_FollowerFollowingModel) _then;

/// Create a copy of FollowerFollowingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? follower = null,Object? following = null,Object? isFollowing = null,}) {
  return _then(_FollowerFollowingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,follower: null == follower ? _self.follower : follower // ignore: cast_nullable_to_non_nullable
as ProfileModel,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as ProfileModel,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FollowerFollowingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<$Res> get follower {
  
  return $ProfileModelCopyWith<$Res>(_self.follower, (value) {
    return _then(_self.copyWith(follower: value));
  });
}/// Create a copy of FollowerFollowingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<$Res> get following {
  
  return $ProfileModelCopyWith<$Res>(_self.following, (value) {
    return _then(_self.copyWith(following: value));
  });
}
}

// dart format on
