import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DialogShower{
  BuildContext _context;

  void showImageDialog(BuildContext context, File image){
    _updateContext(context);
    showDialog(
      context: _context,
      builder: (BuildContext context){
        return _createFileDialog(image);
      }
    );
  }

  Dialog _createFileDialog(File image){
    return Dialog(
      child: Image.file(
        image,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      ),
    );
  }

  void _updateContext(BuildContext context){
    _context = context;
  }
}