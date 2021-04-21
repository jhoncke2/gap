import 'package:flutter/material.dart';
import 'package:gap/old_architecture/errors/error_types.dart';
import '../custom_error.dart';

class UnfoundStorageElementErr extends CustomError{
  final StorageElementType elementType;
  UnfoundStorageElementErr({
    @required this.elementType
  }):super(
    type: ErrorType.UNFOUND_STORAGE_ELEMENT
  );
}

enum StorageElementType{
  AUTH_TOKEN,
  ANOTHER
}