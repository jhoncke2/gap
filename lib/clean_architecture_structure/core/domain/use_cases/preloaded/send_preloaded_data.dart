import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/preloaded_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class SendPreloadedData implements UseCase<void, NoParams>{
  final PreloadedRepository repository;

  SendPreloadedData({
    @required this.repository
  });

  @override
  Future<Either<Failure, void>> call(NoParams params)async{
    return await repository.sendPreloadedData();
  }
}