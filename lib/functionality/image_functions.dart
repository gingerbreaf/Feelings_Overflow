import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


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


}