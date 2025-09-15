// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommentModel {

 int get id; String get comment;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'blog_id') int get blogId;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'vote_count') int get voteCount;@JsonKey(name: 'is_voted') bool get isVoted;@JsonKey(name: 'author') ProfileModel get author;
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentModelCopyWith<CommentModel> get copyWith => _$CommentModelCopyWithImpl<CommentModel>(this as CommentModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.blogId, blogId) || other.blogId == blogId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.isVoted, isVoted) || other.isVoted == isVoted)&&(identical(other.author, author) || other.author == author));
}


@override
int get hashCode => Object.hash(runtimeType,id,comment,userId,blogId,createdAt,voteCount,isVoted,author);

@override
String toString() {
  return 'CommentModel(id: $id, comment: $comment, userId: $userId, blogId: $blogId, createdAt: $createdAt, voteCount: $voteCount, isVoted: $isVoted, author: $author)';
}


}

/// @nodoc
abstract mixin class $CommentModelCopyWith<$Res>  {
  factory $CommentModelCopyWith(CommentModel value, $Res Function(CommentModel) _then) = _$CommentModelCopyWithImpl;
@useResult
$Res call({
 int id, String comment,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'blog_id') int blogId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'vote_count') int voteCount,@JsonKey(name: 'is_voted') bool isVoted,@JsonKey(name: 'author') ProfileModel author
});


$ProfileModelCopyWith<$Res> get author;

}
/// @nodoc
class _$CommentModelCopyWithImpl<$Res>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._self, this._then);

  final CommentModel _self;
  final $Res Function(CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? comment = null,Object? userId = null,Object? blogId = null,Object? createdAt = null,Object? voteCount = null,Object? isVoted = null,Object? author = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,blogId: null == blogId ? _self.blogId : blogId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,isVoted: null == isVoted ? _self.isVoted : isVoted // ignore: cast_nullable_to_non_nullable
as bool,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ProfileModel,
  ));
}
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<$Res> get author {
  
  return $ProfileModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentModel].
extension CommentModelPatterns on CommentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentModel value)  $default,){
final _that = this;
switch (_that) {
case _CommentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String comment, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'blog_id')  int blogId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'vote_count')  int voteCount, @JsonKey(name: 'is_voted')  bool isVoted, @JsonKey(name: 'author')  ProfileModel author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.comment,_that.userId,_that.blogId,_that.createdAt,_that.voteCount,_that.isVoted,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String comment, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'blog_id')  int blogId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'vote_count')  int voteCount, @JsonKey(name: 'is_voted')  bool isVoted, @JsonKey(name: 'author')  ProfileModel author)  $default,) {final _that = this;
switch (_that) {
case _CommentModel():
return $default(_that.id,_that.comment,_that.userId,_that.blogId,_that.createdAt,_that.voteCount,_that.isVoted,_that.author);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String comment, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'blog_id')  int blogId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'vote_count')  int voteCount, @JsonKey(name: 'is_voted')  bool isVoted, @JsonKey(name: 'author')  ProfileModel author)?  $default,) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.comment,_that.userId,_that.blogId,_that.createdAt,_that.voteCount,_that.isVoted,_that.author);case _:
  return null;

}
}

}

/// @nodoc


class _CommentModel extends CommentModel {
  const _CommentModel({this.id = 0, this.comment = '', @JsonKey(name: 'user_id') this.userId = '', @JsonKey(name: 'blog_id') this.blogId = 0, @JsonKey(name: 'created_at') this.createdAt = '', @JsonKey(name: 'vote_count') this.voteCount = 0, @JsonKey(name: 'is_voted') this.isVoted = false, @JsonKey(name: 'author') this.author = const ProfileModel()}): super._();
  

@override@JsonKey() final  int id;
@override@JsonKey() final  String comment;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'blog_id') final  int blogId;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'vote_count') final  int voteCount;
@override@JsonKey(name: 'is_voted') final  bool isVoted;
@override@JsonKey(name: 'author') final  ProfileModel author;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentModelCopyWith<_CommentModel> get copyWith => __$CommentModelCopyWithImpl<_CommentModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.blogId, blogId) || other.blogId == blogId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.isVoted, isVoted) || other.isVoted == isVoted)&&(identical(other.author, author) || other.author == author));
}


@override
int get hashCode => Object.hash(runtimeType,id,comment,userId,blogId,createdAt,voteCount,isVoted,author);

@override
String toString() {
  return 'CommentModel(id: $id, comment: $comment, userId: $userId, blogId: $blogId, createdAt: $createdAt, voteCount: $voteCount, isVoted: $isVoted, author: $author)';
}


}

/// @nodoc
abstract mixin class _$CommentModelCopyWith<$Res> implements $CommentModelCopyWith<$Res> {
  factory _$CommentModelCopyWith(_CommentModel value, $Res Function(_CommentModel) _then) = __$CommentModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String comment,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'blog_id') int blogId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'vote_count') int voteCount,@JsonKey(name: 'is_voted') bool isVoted,@JsonKey(name: 'author') ProfileModel author
});


@override $ProfileModelCopyWith<$Res> get author;

}
/// @nodoc
class __$CommentModelCopyWithImpl<$Res>
    implements _$CommentModelCopyWith<$Res> {
  __$CommentModelCopyWithImpl(this._self, this._then);

  final _CommentModel _self;
  final $Res Function(_CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? comment = null,Object? userId = null,Object? blogId = null,Object? createdAt = null,Object? voteCount = null,Object? isVoted = null,Object? author = null,}) {
  return _then(_CommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,blogId: null == blogId ? _self.blogId : blogId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,isVoted: null == isVoted ? _self.isVoted : isVoted // ignore: cast_nullable_to_non_nullable
as bool,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ProfileModel,
  ));
}

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<$Res> get author {
  
  return $ProfileModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
