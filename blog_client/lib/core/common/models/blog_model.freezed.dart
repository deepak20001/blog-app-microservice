// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlogModel {

 int get id; String get title; String get description;@JsonKey(name: 'image_url') String get imageUrl;@JsonKey(name: 'category_id') String get categoryId;@JsonKey(name: 'author_id') String get authorId;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'vote_count') int get voteCount;@JsonKey(name: 'is_voted') bool get isLiked;@JsonKey(name: 'is_saved') bool get isSaved; ProfileModel get author;
/// Create a copy of BlogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlogModelCopyWith<BlogModel> get copyWith => _$BlogModelCopyWithImpl<BlogModel>(this as BlogModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.author, author) || other.author == author));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,imageUrl,categoryId,authorId,createdAt,voteCount,isLiked,isSaved,author);

@override
String toString() {
  return 'BlogModel(id: $id, title: $title, description: $description, imageUrl: $imageUrl, categoryId: $categoryId, authorId: $authorId, createdAt: $createdAt, voteCount: $voteCount, isLiked: $isLiked, isSaved: $isSaved, author: $author)';
}


}

/// @nodoc
abstract mixin class $BlogModelCopyWith<$Res>  {
  factory $BlogModelCopyWith(BlogModel value, $Res Function(BlogModel) _then) = _$BlogModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'author_id') String authorId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'vote_count') int voteCount,@JsonKey(name: 'is_voted') bool isLiked,@JsonKey(name: 'is_saved') bool isSaved, ProfileModel author
});


$ProfileModelCopyWith<$Res> get author;

}
/// @nodoc
class _$BlogModelCopyWithImpl<$Res>
    implements $BlogModelCopyWith<$Res> {
  _$BlogModelCopyWithImpl(this._self, this._then);

  final BlogModel _self;
  final $Res Function(BlogModel) _then;

/// Create a copy of BlogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imageUrl = null,Object? categoryId = null,Object? authorId = null,Object? createdAt = null,Object? voteCount = null,Object? isLiked = null,Object? isSaved = null,Object? author = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ProfileModel,
  ));
}
/// Create a copy of BlogModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<$Res> get author {
  
  return $ProfileModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [BlogModel].
extension BlogModelPatterns on BlogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlogModel value)  $default,){
final _that = this;
switch (_that) {
case _BlogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlogModel value)?  $default,){
final _that = this;
switch (_that) {
case _BlogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'author_id')  String authorId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'vote_count')  int voteCount, @JsonKey(name: 'is_voted')  bool isLiked, @JsonKey(name: 'is_saved')  bool isSaved,  ProfileModel author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlogModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imageUrl,_that.categoryId,_that.authorId,_that.createdAt,_that.voteCount,_that.isLiked,_that.isSaved,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'author_id')  String authorId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'vote_count')  int voteCount, @JsonKey(name: 'is_voted')  bool isLiked, @JsonKey(name: 'is_saved')  bool isSaved,  ProfileModel author)  $default,) {final _that = this;
switch (_that) {
case _BlogModel():
return $default(_that.id,_that.title,_that.description,_that.imageUrl,_that.categoryId,_that.authorId,_that.createdAt,_that.voteCount,_that.isLiked,_that.isSaved,_that.author);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'author_id')  String authorId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'vote_count')  int voteCount, @JsonKey(name: 'is_voted')  bool isLiked, @JsonKey(name: 'is_saved')  bool isSaved,  ProfileModel author)?  $default,) {final _that = this;
switch (_that) {
case _BlogModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imageUrl,_that.categoryId,_that.authorId,_that.createdAt,_that.voteCount,_that.isLiked,_that.isSaved,_that.author);case _:
  return null;

}
}

}

/// @nodoc


class _BlogModel extends BlogModel {
  const _BlogModel({this.id = 0, this.title = '', this.description = '', @JsonKey(name: 'image_url') this.imageUrl = '', @JsonKey(name: 'category_id') this.categoryId = '', @JsonKey(name: 'author_id') this.authorId = '', @JsonKey(name: 'created_at') this.createdAt = '', @JsonKey(name: 'vote_count') this.voteCount = 0, @JsonKey(name: 'is_voted') this.isLiked = false, @JsonKey(name: 'is_saved') this.isSaved = false, this.author = const ProfileModel()}): super._();
  

@override@JsonKey() final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override@JsonKey(name: 'author_id') final  String authorId;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'vote_count') final  int voteCount;
@override@JsonKey(name: 'is_voted') final  bool isLiked;
@override@JsonKey(name: 'is_saved') final  bool isSaved;
@override@JsonKey() final  ProfileModel author;

/// Create a copy of BlogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlogModelCopyWith<_BlogModel> get copyWith => __$BlogModelCopyWithImpl<_BlogModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.author, author) || other.author == author));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,imageUrl,categoryId,authorId,createdAt,voteCount,isLiked,isSaved,author);

@override
String toString() {
  return 'BlogModel(id: $id, title: $title, description: $description, imageUrl: $imageUrl, categoryId: $categoryId, authorId: $authorId, createdAt: $createdAt, voteCount: $voteCount, isLiked: $isLiked, isSaved: $isSaved, author: $author)';
}


}

/// @nodoc
abstract mixin class _$BlogModelCopyWith<$Res> implements $BlogModelCopyWith<$Res> {
  factory _$BlogModelCopyWith(_BlogModel value, $Res Function(_BlogModel) _then) = __$BlogModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'author_id') String authorId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'vote_count') int voteCount,@JsonKey(name: 'is_voted') bool isLiked,@JsonKey(name: 'is_saved') bool isSaved, ProfileModel author
});


@override $ProfileModelCopyWith<$Res> get author;

}
/// @nodoc
class __$BlogModelCopyWithImpl<$Res>
    implements _$BlogModelCopyWith<$Res> {
  __$BlogModelCopyWithImpl(this._self, this._then);

  final _BlogModel _self;
  final $Res Function(_BlogModel) _then;

/// Create a copy of BlogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imageUrl = null,Object? categoryId = null,Object? authorId = null,Object? createdAt = null,Object? voteCount = null,Object? isLiked = null,Object? isSaved = null,Object? author = null,}) {
  return _then(_BlogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ProfileModel,
  ));
}

/// Create a copy of BlogModel
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
