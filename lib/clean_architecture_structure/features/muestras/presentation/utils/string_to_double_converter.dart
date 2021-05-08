import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class StringToDoubleConverter{
  Either<Failure, List<double>> convert(List<String> stringList){
    try{
      return Right(
        stringList.map((s) => double.parse(s)).toList()
      );
    }catch(err){
      return Left(FormatFailure());
    }
  }
}