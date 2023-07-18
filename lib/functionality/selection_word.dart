
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Word Selector class, deals with word Selection in general by the controller
class WordSelector {
  /// Gets plain Text that is selected by the controller
  static String getPlainTextSelection(QuillController controller) {
    final selection = controller.selection;
    final plainText = controller.document.toPlainText();
    final startIndex = selection.start;
    final endIndex = selection.end;
    final selectedText = plainText.substring(startIndex, endIndex);
    return selectedText;
  }

  /// Takes in a originalController
  ///
  /// Returns a QuillController with the formatted text that was selected
  static QuillController createSelectedTextController(QuillController originalController) {
    final selectedText = getPlainTextSelection(originalController);
    final List<OffsetValue<Style>> textStyles = originalController.getAllIndividualSelectionStyles();
    List<int> endIndex = [];

    final selectedController = QuillController.basic();
    final delta = Delta()
      ..insert(selectedText, Style().toJson());
    selectedController.document.compose(delta, ChangeSource.LOCAL);
    //print(selectedController.document.toDelta().toJson());
    //print(textStyles);
    if (textStyles.length == 0) {  return selectedController;}
    if (textStyles.length == 1) {
      selectedController.formatTextStyle(
          textStyles[0].offset, selectedText.length, textStyles[0].value);
      return selectedController;
    }

    for (int i = 1; i < textStyles.length; i++) {
      endIndex.add(textStyles[i].offset);
    }
    endIndex.add(selectedText.length);

    int index = 0;
    for (OffsetValue<Style> offsetStyle in textStyles) {
      int startOffset = offsetStyle.offset;
      Style style = offsetStyle.value;
      //print('offset: $startOffset, length: ${endIndex[index] - startOffset}, style: $style');
      selectedController.formatTextStyle(startOffset, endIndex[index] - startOffset, style);
      index++;
    }

    return selectedController;
  }



  static Style getSelectionStyle(QuillController controller) {
    final style = controller.getSelectionStyle();
    return style;
  }




}