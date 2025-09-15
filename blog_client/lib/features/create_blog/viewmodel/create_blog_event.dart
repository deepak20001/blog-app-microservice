part of 'create_blog_bloc.dart';

abstract class CreateBlogEvent extends Equatable {
  const CreateBlogEvent();

  @override
  List<Object?> get props => [];
}

// Pick Image Event
class CreateBlogPickImageEvent extends CreateBlogEvent {
  const CreateBlogPickImageEvent();

  @override
  List<Object?> get props => [];
}

// Get Categories Event
class CreateBlogGetCategoriesEvent extends CreateBlogEvent {
  const CreateBlogGetCategoriesEvent();

  @override
  List<Object?> get props => [];
}

// Select Category Event
class CreateBlogSelectCategoryEvent extends CreateBlogEvent {
  const CreateBlogSelectCategoryEvent({required this.categoryId});
  final int categoryId;

  @override
  List<Object?> get props => [categoryId];
}

// Upload Image Event
class CreateBlogUploadImageEvent extends CreateBlogEvent {
  const CreateBlogUploadImageEvent();

  @override
  List<Object?> get props => [];
}

// Create Blog Event
class CreateBlogCreateBlogEvent extends CreateBlogEvent {
  const CreateBlogCreateBlogEvent({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.categoryId,
  });
  final String title;
  final String description;
  final String imagePath;
  final int categoryId;

  @override
  List<Object?> get props => [title, description, imagePath, categoryId];
}
