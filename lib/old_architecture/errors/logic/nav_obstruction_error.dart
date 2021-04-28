import '../custom_error.dart';

class NavObstructionErr extends CustomError{
  final String message;

  NavObstructionErr({
    this.message = 'Ocurrió un error'
  });
}