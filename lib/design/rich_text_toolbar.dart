import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';


/// Rich Text Toolbar that is seen in creating a diary
class RichTextToolbar extends StatelessWidget {
  /// Controller which contains information about the inputs
  final QuillController controller;
  /// Buttons in the Quill Toolbar that can be custom added
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