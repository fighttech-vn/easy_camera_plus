import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DeviceService {
  Future<String> createPath() async {

    final  appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();

    return '$videoDirectory/$currentTime.mp4';
     
  }
}