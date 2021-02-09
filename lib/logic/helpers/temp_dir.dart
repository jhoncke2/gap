import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TempDir{
  static Future<String> getFilePath(String fileName)async{
    final Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    tempPath += '$fileName.png';
    return tempPath;
  }
}