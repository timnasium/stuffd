import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';

Future<File?> getImageFile() async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.image);

  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else {
    return null;
  }
}

Image imageFromBase64OrURL(String s) {
  if (Uri.parse(s).host.isNotEmpty) {
    return Image.network(s);
  } else {
    return imageFromBase64String(s);
  }
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

String base64StringFromFile(File f) {
  Uint8List bytes = f.readAsBytesSync();
  return base64Encode(bytes);
}
