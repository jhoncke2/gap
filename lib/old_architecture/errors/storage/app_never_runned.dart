import 'package:gap/old_architecture/errors/custom_error.dart';

import '../error_types.dart';

class AppNeverRunnedErr extends CustomError{
  AppNeverRunnedErr():super(type: ErrorType.APP_NEVER_RUNNED);
}