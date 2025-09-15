import 'dart:developer' as devtools show log;
import 'package:blog_client/features/blogs/models/category_model.dart';
import 'package:blog_client/features/create_blog/repositories/create_blog_remote_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'create_blog_event.dart';
part 'create_blog_state.dart';

@singleton
class CreateBlogBloc extends Bloc<CreateBlogEvent, CreateBlogState> {
  CreateBlogBloc({
    required CreateBlogRemoteRepository createBlogRemoteRepository,
  }) : _createBlogRemoteRepository = createBlogRemoteRepository,
       super(const CreateBlogInitialState()) {
    on<CreateBlogPickImageEvent>(_onCreateBlogPickImageRequested);
    on<CreateBlogGetCategoriesEvent>(_onCreateBlogGetCategoriesRequested);
    on<CreateBlogSelectCategoryEvent>(_onCreateBlogSelectCategoryRequested);
    on<CreateBlogUploadImageEvent>(_onCreateBlogUploadImageRequested);
    on<CreateBlogCreateBlogEvent>(_onCreateBlogCreateBlogRequested);
  }
  final CreateBlogRemoteRepository _createBlogRemoteRepository;

  // Handle pick image
  Future<void> _onCreateBlogPickImageRequested(
    CreateBlogPickImageEvent event,
    Emitter<CreateBlogState> emit,
  ) async {
    if (state is CreateBlogPickImageLoadingState) return;
    emit(
      CreateBlogPickImageLoadingState(
        imagePath: state.imagePath,
        categories: state.categories,
      ),
    );
    try {
      final result = await _createBlogRemoteRepository.pickImage();

      await result.fold(
        (failure) {
          devtools.log('Pick image failed: ${failure.message}');
          emit(
            CreateBlogPickImageFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
              categories: state.categories,
            ),
          );
        },
        (data) async {
          final imagePath = data;
          emit(
            CreateBlogPickImageSuccessState(
              imagePath: imagePath,
              categories: state.categories,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during pick image: $e',
        stackTrace: stackTrace,
      );
      emit(
        CreateBlogPickImageFailureState(
          imagePath: state.imagePath,
          errorMessage: 'An unexpected error occurred. Please try again.',
          categories: state.categories,
        ),
      );
    }
  }

  // Handle get categories
  Future<void> _onCreateBlogGetCategoriesRequested(
    CreateBlogGetCategoriesEvent event,
    Emitter<CreateBlogState> emit,
  ) async {
    if (state is CreateBlogGetCategoriesLoadingState) return;
    emit(CreateBlogGetCategoriesLoadingState());
    try {
      final result = await _createBlogRemoteRepository.categories();

      await result.fold(
        (failure) {
          devtools.log('Get categories failed: ${failure.message}');
          emit(
            CreateBlogGetCategoriesFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
            ),
          );
        },
        (List<CategoryModel> categories) async {
          emit(
            CreateBlogGetCategoriesSuccessState(
              categories: categories,
              imagePath: state.imagePath,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get categories: $e',
        stackTrace: stackTrace,
      );
      emit(
        CreateBlogGetCategoriesFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          imagePath: state.imagePath,
        ),
      );
    }
  }

  // Handle select category
  Future<void> _onCreateBlogSelectCategoryRequested(
    CreateBlogSelectCategoryEvent event,
    Emitter<CreateBlogState> emit,
  ) async {
    if (state.categories.any((category) => category.id == event.categoryId)) {
      final updatedCategories = state.categories.map((category) {
        if (category.id == event.categoryId) {
          return category.copyWith(isSelected: true);
        }
        return category.copyWith(isSelected: false);
      }).toList();
      emit(
        CreateBlogSelectCategoryState(
          imagePath: state.imagePath,
          categoryId: event.categoryId,
          categories: updatedCategories,
        ),
      );
    }
  }

  // Handle upload image
  Future<void> _onCreateBlogUploadImageRequested(
    CreateBlogUploadImageEvent event,
    Emitter<CreateBlogState> emit,
  ) async {
    if (state is CreateBlogUploadImageLoadingState) return;
    emit(
      CreateBlogUploadImageLoadingState(
        imagePath: state.imagePath,
        categories: state.categories,
      ),
    );
    try {
      final result = await _createBlogRemoteRepository.uploadImage(
        imagePath: state.imagePath,
      );

      await result.fold(
        (failure) {
          devtools.log('Upload image failed: ${failure.message}');
          emit(
            CreateBlogUploadImageFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
              categories: state.categories,
            ),
          );
        },
        (String uploadedImagePath) async {
          emit(
            CreateBlogUploadImageSuccessState(
              imagePath: state.imagePath,
              categories: state.categories,
              uploadedImagePath: uploadedImagePath,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during upload image: $e',
        stackTrace: stackTrace,
      );
      emit(
        CreateBlogUploadImageFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          imagePath: state.imagePath,
          categories: state.categories,
        ),
      );
    }
  }

  // Handle create blog
  Future<void> _onCreateBlogCreateBlogRequested(
    CreateBlogCreateBlogEvent event,
    Emitter<CreateBlogState> emit,
  ) async {
    if (state is CreateBlogCreateBlogLoadingState) return;
    emit(
      CreateBlogCreateBlogLoadingState(
        imagePath: state.imagePath,
        categories: state.categories,
      ),
    );
    try {
      final result = await _createBlogRemoteRepository.createBlog(
        imagePath: event.imagePath,
        title: event.title,
        description: event.description,
        categoryId: event.categoryId,
      );

      await result.fold(
        (failure) {
          devtools.log('Create blog failed: ${failure.message}');
          emit(
            CreateBlogCreateBlogFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
              categories: state.categories,
            ),
          );
        },
        (String message) async {
          emit(CreateBlogCreateBlogSuccessState(categories: state.categories));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during create blog: $e',
        stackTrace: stackTrace,
      );
      emit(
        CreateBlogCreateBlogFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          imagePath: state.imagePath,
          categories: state.categories,
        ),
      );
    }
  }
}
