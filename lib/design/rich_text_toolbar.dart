import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichTextToolbar extends StatelessWidget {


  final QuillController controller;
  final List<QuillCustomButton> customButtons = [];

  RichTextToolbar({Key? key,
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
      showCenterAlignment: true,
      showAlignmentButtons: true,

    );
  }
}