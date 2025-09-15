import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_button.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
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
  final HtmlEditorController _htmlController = HtmlEditorController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CreateBlogBloc _createBlogBloc = getIt<CreateBlogBloc>();
  String html = '';

  @override
  void initState() {
    super.initState();
    _createBlogBloc.add(const CreateBlogGetCategoriesEvent());
  }

  Future<void> _onUploadImage() async {
    if (_formKey.currentState?.validate() ?? false) {
      html = await _htmlController.getText();
      if (html.trim().isEmpty || html == '<p></p>') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Description is required')),
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
          description: html,
          imagePath: uploadedImagePath,
          categoryId: categoryId,
        ),
      );
    }
  }

  void _onBlocListener(BuildContext context, CreateBlogState state) {
    switch (state) {
      case CreateBlogGetCategoriesFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      case CreateBlogUploadImageSuccessState(:final uploadedImagePath):
        _onCreateBlog(uploadedImagePath);
        break;
      case CreateBlogUploadImageFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
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
                      validator: (value) =>
                          ValidationHelper.validateRequiredFields(
                            value: value,
                            fieldName: 'Title',
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
                    CommonText(
                      text: 'Description',
                      style: context.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    BuildHtmlEditor(
                      htmlController: _htmlController,
                      size: size,
                    ),
                    CommonButton(text: 'Create', onPressed: _onUploadImage),
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
