import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';

@freezed
sealed class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required String title,
    @Default(false) bool isSelected,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
  }) = _CategoryModel;
  const CategoryModel._();

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
