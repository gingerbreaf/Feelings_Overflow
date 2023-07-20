import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';

class RichTextColourToolbar extends StatelessWidget {


  final QuillController controller;
  final List<QuillCustomButton> customButtons = [];

  RichTextColourToolbar({Key? key,
    required this.controller,
    customButtons,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return QuillToolbar.basic(
      controller: controller,
      multiRowsDisplay: false,
      showListCheck: false,
      showSearchButton: false,
      showHeaderStyle: false,
      showSubscript: false,
      showSuperscript: false,
      showIndent: false,
      showCenterAlignment: false,
      showAlignmentButtons: false,
      showFontFamily: false,
      showRedo: false,
      showUndo: false,
      showUnderLineButton: false,
      showFontSize: false,
      showBoldButton: false,
      showItalicButton: false,
      showStrikeThrough: false,
      showCodeBlock: false,
      showBackgroundColorButton: false,
      showInlineCode: false,
      showListBullets: false,
      showListNumbers: false,
      showQuote: false,
      showLink: false,
      showJustifyAlignment: false,
      showDividers: false,
      showDirection: false,
      showColorButton: true,
      showClearFormat: false,
    );
  }
}