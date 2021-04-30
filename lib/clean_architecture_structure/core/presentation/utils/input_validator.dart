import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class InputValidator{
  Either<Failure, void> validateInputValue(String inputValue){
    if([null, ''].contains(inputValue))
      return Left(InvalidInputFailure());
    return Right(null);
  }
}