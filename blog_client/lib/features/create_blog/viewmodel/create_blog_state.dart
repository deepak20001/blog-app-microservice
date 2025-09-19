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
  const CreateBlogCreateBlogSuccessState({
    required super.categories,
    required this.successMessage,
  });
  final String successMessage;

  @override
  List<Object?> get props => [successMessage, imagePath, categories];
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

// Generate Ai Title States
class CreateBlogGenerateAiTitleLoadingState extends CreateBlogState {
  const CreateBlogGenerateAiTitleLoadingState({
    required super.imagePath,
    required super.categories,
  });
}

class CreateBlogGenerateAiTitleSuccessState extends CreateBlogState {
  const CreateBlogGenerateAiTitleSuccessState({
    required super.imagePath,
    required super.categories,
    required this.aiTitle,
  });
  final String aiTitle;

  @override
  List<Object?> get props => [aiTitle, imagePath, categories];
}

class CreateBlogGenerateAiTitleFailureState extends CreateBlogState {
  const CreateBlogGenerateAiTitleFailureState({
    required super.imagePath,
    required super.categories,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, categories];
}

// Generate Ai Short Description States
class CreateBlogGenerateAiShortDescriptionLoadingState extends CreateBlogState {
  const CreateBlogGenerateAiShortDescriptionLoadingState({
    required super.imagePath,
    required super.categories,
  });
}

class CreateBlogGenerateAiShortDescriptionSuccessState extends CreateBlogState {
  const CreateBlogGenerateAiShortDescriptionSuccessState({
    required super.imagePath,
    required super.categories,
    required this.aiShortDescription,
  });
  final String aiShortDescription;

  @override
  List<Object?> get props => [aiShortDescription, imagePath, categories];
}

class CreateBlogGenerateAiShortDescriptionFailureState extends CreateBlogState {
  const CreateBlogGenerateAiShortDescriptionFailureState({
    required super.imagePath,
    required super.categories,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, categories];
}

// Generate Ai Description States
class CreateBlogGenerateAiDescriptionLoadingState extends CreateBlogState {
  const CreateBlogGenerateAiDescriptionLoadingState({
    required super.imagePath,
    required super.categories,
  });
}

class CreateBlogGenerateAiDescriptionSuccessState extends CreateBlogState {
  const CreateBlogGenerateAiDescriptionSuccessState({
    required super.imagePath,
    required super.categories,
    required this.aiDescription,
  });
  final String aiDescription;

  @override
  List<Object?> get props => [aiDescription, imagePath, categories];
}

class CreateBlogGenerateAiDescriptionFailureState extends CreateBlogState {
  const CreateBlogGenerateAiDescriptionFailureState({
    required super.imagePath,
    required super.categories,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, categories];
}
