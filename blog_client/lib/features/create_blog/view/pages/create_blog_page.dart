import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_button.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/core/utils/validation_helper.dart';
import 'package:blog_client/features/create_blog/view/widgets/build_category_selection.dart';
import 'package:blog_client/features/create_blog/view/widgets/build_html_editor.dart';
import 'package:blog_client/features/create_blog/view/widgets/build_image_pick_section.dart';
import 'package:blog_client/features/create_blog/viewmodel/create_blog_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';

@RoutePage()
class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final HtmlEditorController _htmlController = HtmlEditorController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CreateBlogBloc _createBlogBloc = getIt<CreateBlogBloc>();
  String html = '';

  @override
  void initState() {
    super.initState();
    _createBlogBloc.add(const CreateBlogGetCategoriesEvent());
  }

  // Handle upload image
  Future<void> _onUploadImage() async {
    if (_formKey.currentState?.validate() ?? false) {
      html = await _htmlController.getText();
      if (html.trim().isEmpty || html == '<p></p>') {
        SnackbarUtils.showError(
          context: context,
          message: 'Description is required',
        );
        return;
      } else if (!_createBlogBloc.state.categories.any(
        (category) => category.isSelected,
      )) {
        SnackbarUtils.showError(
          context: context,
          message: 'Category is required',
        );
        return;
      }
      _createBlogBloc.add(CreateBlogUploadImageEvent());
    }
  }

  // Handle create blog
  Future<void> _onCreateBlog(String uploadedImagePath) async {
    if (_formKey.currentState?.validate() ?? false) {
      final categoryId = _createBlogBloc.state.categories
          .firstWhere((category) => category.isSelected)
          .id;
      if (categoryId == -1) {
        SnackbarUtils.showError(
          context: context,
          message: 'Category is required',
        );
        return;
      }
      _createBlogBloc.add(
        CreateBlogCreateBlogEvent(
          title: _titleController.text.trim(),
          shortDescription: _shortDescriptionController.text.trim(),
          description: html,
          imagePath: uploadedImagePath,
          categoryId: categoryId,
        ),
      );
    }
  }

  // Handle generate ai title
  void _onGenerateAiTitle() {
    if (_titleController.text.trim().isEmpty) {
      SnackbarUtils.showError(context: context, message: 'Title is required');
      return;
    }
    _createBlogBloc.add(
      CreateBlogGenerateAiTitleEvent(title: _titleController.text.trim()),
    );
  }

  // Handle generate ai short description
  void _onGenerateAiShortDescription() {
    if (_titleController.text.trim().isEmpty) {
      SnackbarUtils.showError(context: context, message: 'Title is required');
      return;
    }
    if (_shortDescriptionController.text.trim().isEmpty) {
      SnackbarUtils.showError(
        context: context,
        message: 'Short description is required',
      );
      return;
    }
    _createBlogBloc.add(
      CreateBlogGenerateAiShortDescriptionEvent(
        title: _titleController.text.trim(),
        shortDescription: _shortDescriptionController.text.trim(),
      ),
    );
  }

  // Handle generate ai description
  Future<void> _onGenerateAiDescription() async {
    if (_titleController.text.trim().isEmpty) {
      SnackbarUtils.showError(context: context, message: 'Title is required');
      return;
    }
    if (_shortDescriptionController.text.trim().isEmpty) {
      SnackbarUtils.showError(
        context: context,
        message: 'Short description is required',
      );
      return;
    }

    final currentHtml = await _htmlController.getText();
    _createBlogBloc.add(
      CreateBlogGenerateAiDescriptionEvent(
        title: _titleController.text.trim(),
        shortDescription: _shortDescriptionController.text.trim(),
        description: currentHtml,
      ),
    );
  }

  void _onBlocListener(BuildContext context, CreateBlogState state) {
    switch (state) {
      case CreateBlogGetCategoriesFailureState(:final errorMessage) ||
          CreateBlogGenerateAiTitleFailureState(:final errorMessage) ||
          CreateBlogGenerateAiShortDescriptionFailureState(
            :final errorMessage,
          ) ||
          CreateBlogGenerateAiDescriptionFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      case CreateBlogGenerateAiTitleSuccessState(:final aiTitle):
        _titleController.text = aiTitle;
        break;
      case CreateBlogGenerateAiShortDescriptionSuccessState(
        :final aiShortDescription,
      ):
        _shortDescriptionController.text = aiShortDescription;
        break;
      case CreateBlogGenerateAiDescriptionSuccessState(:final aiDescription):
        _htmlController.setText(aiDescription);
        break;
      case CreateBlogUploadImageSuccessState(:final uploadedImagePath):
        _onCreateBlog(uploadedImagePath);
        break;
      case CreateBlogUploadImageFailureState(:final errorMessage) ||
          CreateBlogCreateBlogFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      case CreateBlogCreateBlogSuccessState():
        context.router.maybePop();
        SnackbarUtils.showSuccess(
          context: context,
          message: 'Blog created successfully',
        );
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<CreateBlogBloc, CreateBlogState>(
      bloc: _createBlogBloc,
      listener: _onBlocListener,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Blog', style: context.titleLarge),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: context.paddingSymmetric(
              horizontal: numD035,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: size.width * numD035,
                  children: [
                    CommonTextFormField(
                      controller: _titleController,
                      hintText: 'Enter title',
                      label: 'Title',
                      maxLength: 200,
                      showCharacterCount: true,
                      suffixIcon:
                          BlocSelector<CreateBlogBloc, CreateBlogState, bool>(
                            bloc: _createBlogBloc,
                            selector: (state) =>
                                state is CreateBlogGenerateAiTitleLoadingState,
                            builder: (context, isLoading) {
                              return IconButton(
                                tooltip: 'AI generate title',
                                onPressed: isLoading
                                    ? null
                                    : _onGenerateAiTitle,
                                icon: isLoading
                                    ? SizedBox(
                                        width: size.width * numD06,
                                        height: size.width * numD06,
                                        child: Loader(
                                          color: AppPallete.primaryColor,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.auto_awesome,
                                        color: AppPallete.primaryColor,
                                      ),
                              );
                            },
                          ),
                      validator: (value) =>
                          ValidationHelper.validateRequiredFields(
                            value: value,
                            fieldName: 'Title',
                          ),
                    ),
                    CommonTextFormField(
                      controller: _shortDescriptionController,
                      hintText: 'Enter short description',
                      label: 'Short Description',
                      maxLines: 3,
                      maxLength: 255,
                      showCharacterCount: true,
                      suffixIcon:
                          BlocSelector<CreateBlogBloc, CreateBlogState, bool>(
                            bloc: _createBlogBloc,
                            selector: (state) =>
                                state
                                    is CreateBlogGenerateAiShortDescriptionLoadingState,
                            builder: (context, isLoading) {
                              return IconButton(
                                tooltip: 'AI generate short description',
                                onPressed: isLoading
                                    ? null
                                    : _onGenerateAiShortDescription,
                                icon: isLoading
                                    ? SizedBox(
                                        width: size.width * numD06,
                                        height: size.width * numD06,
                                        child: Loader(
                                          color: AppPallete.primaryColor,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.auto_awesome,
                                        color: AppPallete.primaryColor,
                                      ),
                              );
                            },
                          ),
                      validator: (value) =>
                          ValidationHelper.validateRequiredFields(
                            value: value,
                            fieldName: 'Short Description',
                          ),
                    ),
                    BuildImagePickSection(
                      size: size,
                      createBlogBloc: _createBlogBloc,
                    ),
                    BuildCategorySelection(
                      size: size,
                      createBlogBloc: _createBlogBloc,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          text: 'Description',
                          style: context.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        BlocSelector<CreateBlogBloc, CreateBlogState, bool>(
                          bloc: _createBlogBloc,
                          selector: (state) =>
                              state
                                  is CreateBlogGenerateAiDescriptionLoadingState,
                          builder: (context, isLoading) {
                            return IconButton(
                              tooltip: 'AI generate description',
                              onPressed: isLoading
                                  ? null
                                  : _onGenerateAiDescription,
                              icon: isLoading
                                  ? SizedBox(
                                      width: size.width * numD06,
                                      height: size.width * numD06,
                                      child: Loader(
                                        color: AppPallete.primaryColor,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.auto_awesome,
                                      color: AppPallete.primaryColor,
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                    BuildHtmlEditor(
                      htmlController: _htmlController,
                      size: size,
                    ),
                    BlocSelector<CreateBlogBloc, CreateBlogState, bool>(
                      selector: (state) {
                        return state is CreateBlogUploadImageLoadingState ||
                            state is CreateBlogCreateBlogLoadingState;
                      },
                      builder: (context, isLoading) {
                        return CommonButton(
                          isLoading: isLoading,
                          text: 'Create',
                          onPressed: _onUploadImage,
                        );
                      },
                    ),
                    context.sizedBoxHeight(numD05),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
