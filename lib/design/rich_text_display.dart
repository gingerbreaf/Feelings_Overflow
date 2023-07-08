import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichTextDisplay extends StatelessWidget {

  final QuillController controller;

  const RichTextDisplay({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
        controller: controller,
        focusNode: FocusNode(),
        scrollController: ScrollController(),
        scrollable: true,
        padding: const EdgeInsets.all(0),
        autoFocus: false,
        readOnly: true,
        expands: false,
        showCursor: false,
    );
  }
}
