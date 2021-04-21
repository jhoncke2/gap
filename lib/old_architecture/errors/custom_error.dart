import 'package:flutter/material.dart';

abstract class CustomError extends Error{
  final type;
  String message;
  dynamic extraInformation;

  CustomError({@required this.type, this.message, this.extraInformation});
}