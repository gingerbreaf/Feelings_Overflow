import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageFunction {
  /// Allows users to select an image from their photo gallery
  static pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      // We do not use dart:io related packages since they are not accessible on the web
      // could return File(_file.path); as another method
      return await file.readAsBytes();
    }
  }

  /// Uploads a picture to Firebase Storage
  static Future<void> uploadFile(
    Uint8List filePath,
    String fileName,
  ) async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child('user profile pictures/$fileName')
          .putData(filePath);
    } catch (e) {
      print(e);
    }
  }

  /// Gets the download URL of the specified file in Firebase Storage
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
