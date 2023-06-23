import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageFunction {
  static pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      // We do not use dart:io related packages since they are not accessible on the web
      // could return File(_file.path); as another method
      return await _file.readAsBytes();
    }
    print('No images selected');
  }

  static Future<void> uploadFile(
      Uint8List filePath,
      String fileName,
      ) async {
    try {
      await FirebaseStorage.instance.ref().child('user profile pictures/$fileName').putData(filePath);
    } catch (e) {
      print(e);
    }
  }

  static Future<String> getDownloadURL(String fileName) async {
    try {
      return await FirebaseStorage.instance
          .ref()
          .child('user profile pictures/$fileName')
          .getDownloadURL();
    } catch (e) {
      return "";
    }
  }
}
