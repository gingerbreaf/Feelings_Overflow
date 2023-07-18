import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';


class TextFormatting {
  /// Takes in a quillController
  ///
  /// Returns a formatted display text in a particular Font style
  static QuillController formatTextStyle(QuillController quillController, String fontFamily) {
    final Style baseStyle = Style();
    FontAttribute fontAttribute = FontAttribute(fontFamily);
    final Style modifiedStyle = baseStyle.put(fontAttribute);
    quillController.formatTextStyle(0, quillController.document.length, modifiedStyle);

    return quillController;
  }

  static QuillController formatSize(QuillController quillController, String size) {
    final Style baseStyle = Style();
    SizeAttribute sizeAttribute = SizeAttribute(size);
    final Style modifiedStyle = baseStyle.put(sizeAttribute);
    quillController.formatTextStyle(0, quillController.document.length, modifiedStyle);

    return quillController;
  }


}