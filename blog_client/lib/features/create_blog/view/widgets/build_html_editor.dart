import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class BuildHtmlEditor extends StatelessWidget {
  const BuildHtmlEditor({
    super.key,
    required this.htmlController,
    required this.size,
  });
  final HtmlEditorController htmlController;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        border: Border.all(color: AppPallete.greyColor300),
      ),
      child: Column(
        children: [
          HtmlEditor(
            controller: htmlController,
            htmlEditorOptions: HtmlEditorOptions(
              hint: 'Write a rich description...',
              shouldEnsureVisible: true,
            ),
            callbacks: Callbacks(onFocus: () {}),
            htmlToolbarOptions: HtmlToolbarOptions(
              defaultToolbarButtons: const [
                FontButtons(),
                ColorButtons(),
                ListButtons(),
                ParagraphButtons(
                  textDirection: false,
                  caseConverter: false,
                  lineHeight: false,
                ),
                InsertButtons(
                  video: false,
                  table: false,
                  audio: false,
                  picture: false,
                  link: false,
                  otherFile: false,
                ),
                OtherButtons(
                  fullscreen: false,
                  codeview: true,
                  undo: true,
                  redo: true,
                  help: false,
                ),
              ],
              toolbarType: ToolbarType.nativeScrollable,
              buttonColor: AppPallete.textPrimary,
              buttonFillColor: AppPallete.backgroundColor,
              renderSeparatorWidget: true,
            ),
            otherOptions: OtherOptions(height: size.width * numD9),
          ),
          Container(height: 1, color: AppPallete.greyColor300),
        ],
      ),
    );
  }
}
