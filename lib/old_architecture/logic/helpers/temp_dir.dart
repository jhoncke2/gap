import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TempDir{
  static Future<String> getImgPath(String fileName)async{
    final Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String uniqueNamePart = _createUniqueString();
    tempPath += '${fileName}_$uniqueNamePart.png';
    return tempPath;
  }

  static String _createUniqueString(){
    final DateTime nowTime = DateTime.now();
    return '${nowTime.year}${nowTime.month}${nowTime.day}${nowTime.minute}${nowTime.second}${nowTime.millisecond}';
  }
}