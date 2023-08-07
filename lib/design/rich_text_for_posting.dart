import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Display for the Rich Text for posting
class RichTextDisplayPost extends StatelessWidget {

  final QuillController controller;
  final bool interactive;

  const RichTextDisplayPost({
    super.key,
    required this.controller,
    required this.interactive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: QuillEditor(
        textSelectionControls: MaterialTextSelectionControls(),
        controller: controller,
        focusNode: FocusNode(),
        scrollController: ScrollController(),
        scrollable: true,
        padding: const EdgeInsets.all(0),
        autoFocus: false,
        readOnly: true,
        expands: false,
        showCursor: false,
        enableInteractiveSelection: interactive,
      ),
    );
  }
}
