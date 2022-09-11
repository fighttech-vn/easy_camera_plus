import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageService {
  static Future<String?> cropSquare(
    String srcFilePath,
    String destFilePath,
    Size sizeFrame,
  ) async {
    final bytes = await File(srcFilePath).readAsBytes();
    final img.Image? src = img.decodeImage(bytes);

    if (src != null) {
      final dxCrop = src.width / 2 - sizeFrame.width / 2;
      final dyCrop = src.height / 2 - sizeFrame.height / 2;

      final destImage = img.copyCrop(
        src,
        dxCrop.toInt(),
        dyCrop.toInt(),
        sizeFrame.width.toInt(),
        sizeFrame.height.toInt(),
      );

      final jpg = img.encodeJpg(destImage);
      await File(destFilePath).writeAsBytes(jpg);

      return destFilePath;
    }

    return null;
  }
}
