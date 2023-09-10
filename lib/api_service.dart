import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foodie/common_widgets/snackbar.dart';

String url = "http://10.0.2.2:7000/predict";

uploadFile(
  File image, {
  @required Function(Map)? success,
  @required Function(String)? failed,
}) async {
  Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    
  };
  String fileName = _getFileNameFromFile(image);

  Dio dio = Dio();

  print(image.path);
  print(url);
  var formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(image.path, filename: fileName),
  });

  final response = await Dio().request(
    url,
    data: formData,
    options: Options(
      method: 'POST',
    ),
  );

  if (response.statusCode == 200) {
   
    // var map = response.data as Map;
    final Map<String, dynamic> responseJson =
        response.data as Map<String, dynamic>;
    // final responseJson = json.decode(response.data);

    success!(responseJson);
  } else {
    failed!(response.statusMessage.toString());
  }
}

String _getFileNameFromFile(File file) {
  String filePath = file.path;
  List<String> parts = filePath.split('/');
  String fileName = parts.last;
  return fileName;
}
