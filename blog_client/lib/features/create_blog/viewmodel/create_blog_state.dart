part of 'create_blog_bloc.dart';

sealed class CreateBlogState extends Equatable {
  const CreateBlogState({
    this.imagePath = '',
    this.categories = const <CategoryModel>[],
  });
  final String imagePath;
  final List<CategoryModel> categories;

  @override
  List<Object?> get props => [imagePath, categories];
}

class CreateBlogInitialState extends CreateBlogState {
  const CreateBlogInitialState() : super();
}

// Pick Image States
class CreateBlogPickImageLoadingState extends CreateBlogState {
  const CreateBlogPickImageLoadingState({
    required super.imagePath,
    required super.categories,
  });
}

class CreateBlogPickImageSuccessState extends CreateBlogState {
  const CreateBlogPickImageSuccessState({
    required super.imagePath,
    required super.categories,
  });
}

class CreateBlogPickImageFailureState extends CreateBlogState {
  const CreateBlogPickImageFailureState({
    required super.imagePath,
    required super.categories,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, categories];
}

// Get Categories States
class CreateBlogGetCategoriesLoadingState extends CreateBlogState {
  const CreateBlogGetCategoriesLoadingState();
}

class CreateBlogGetCategoriesSuccessState extends CreateBlogState {
  const CreateBlogGetCategoriesSuccessState({
    required super.imagePath,
    required super.categories,
  });
}

class CreateBlogGetCategoriesFailureState extends CreateBlogState {
  const CreateBlogGetCategoriesFailureState({
    required super.imagePath,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath];
}

// Select Category States
class CreateBlogSelectCategoryState extends CreateBlogState {
  const CreateBlogSelectCategoryState({
    required super.imagePath,
    required this.categoryId,
    required super.categories,
  });
  final int categoryId;

  @override
  List<Object?> get props => [categoryId, imagePath, categories];
}

// Upload Image States
class CreateBlogUploadImageLoadingState extends CreateBlogState {
  const CreateBlogUploadImageLoadingState({
    required super.imagePath,
    required super.categories,
  });
}

class CreateBlogUploadImageSuccessState extends CreateBlogState {
  const CreateBlogUploadImageSuccessState({
    required super.imagePath,
    required super.categories,
    required this.uploadedImagePath,
  });
  final String uploadedImagePath;

  @override
  List<Object?> get props => [uploadedImagePath, imagePath, categories];
}

class CreateBlogUploadImageFailureState extends CreateBlogState {
  const CreateBlogUploadImageFailureState({
    required super.imagePath,
    required super.categories,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, categories];
}

// Create Blog States
class CreateBlogCreateBlogLoadingState extends CreateBlogState {
  const CreateBlogCreateBlogLoadingState({
    required super.imagePath,
    required super.categories,
  });
}

class CreateBlogCreateBlogSuccessState extends CreateBlogState {
  const CreateBlogCreateBlogSuccessState({required super.categories});
}

class CreateBlogCreateBlogFailureState extends CreateBlogState {
  const CreateBlogCreateBlogFailureState({
    required super.imagePath,
    required super.categories,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, categories];
}
