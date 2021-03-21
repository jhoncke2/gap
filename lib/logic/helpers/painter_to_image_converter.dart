import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:gap/logic/helpers/temp_dir.dart';

import 'package:flutter/material.dart';
import 'package:gap/ui/pages/formulario_detail/forms/form_body/center_containers/firm_fields/firm_draw_field/firm_paint.dart';

class PainterToImageConverter{

  static final Size _imgsSize = Size(350, 350);

  static Future<File> createFileFromFirmPainter(FirmPainter painter, int firmIndex)async{
    final ByteData byteData = await _convertPainterToByteData(painter);
    final ByteBuffer dataBuffer = byteData.buffer;
    final String tempPath = await TempDir.getImgPath('/firm$firmIndex');
    return File(tempPath).writeAsBytes(
      dataBuffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)
    );
  }

  static Future<ByteData> _convertPainterToByteData(FirmPainter painter)async{
    final recorder = new PictureRecorder();
    _paintPainter(painter, recorder);
    final Picture picture = recorder.endRecording();
    final image = await picture.toImage(_imgsSize.width.toInt(), _imgsSize.height.toInt());
    final ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData;
  }

  static void _paintPainter(FirmPainter painter, PictureRecorder recorder){
    final canvas = new Canvas(recorder);
    painter.paint(canvas, _imgsSize);
  }
}