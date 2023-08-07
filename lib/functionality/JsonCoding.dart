import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';

/// JsonCoding is used to retrieve information using JSONData for rich text
class JsonCoding{

  /// Return a QuillController which has the decoded diary Text
  ///
  /// Takes in a JSON formatted String in Firebase Database
  static QuillController getQuillControllerviaJSON(String JSONData) {
    var myJSON = jsonDecode(JSONData);
    return QuillController(
      document: Document.fromJson(myJSON),
      selection: TextSelection.collapsed(offset: 0));
  }




}