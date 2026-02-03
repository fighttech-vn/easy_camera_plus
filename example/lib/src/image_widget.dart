import 'dart:io';
import 'package:flutter/material.dart';

class LocalImageRenderer extends StatelessWidget {
  final String imagePath;

  const LocalImageRenderer({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);

    return FutureBuilder<bool>(
      future: file.exists(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.file(file);
        } else {
          return const CircularProgressIndicator(); // Or a placeholder
        }
      },
    );
  }
}
