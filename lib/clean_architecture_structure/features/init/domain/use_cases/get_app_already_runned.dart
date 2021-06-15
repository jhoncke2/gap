import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class GetAppAlreadyRunned implements UseCase<bool, NoParams>{
  final CentralSystemRepository repository;
  final UseCaseErrorHandler errorHandler;

  GetAppAlreadyRunned({
    @required this.repository, 
    @required this.errorHandler
  });
  
  @override
  Future<Either<Failure, bool>> call(NoParams params)async{
    final appAlreadyRunned = await errorHandler.executeFunction(() => repository.getAppRunnedAnyTime());
    appAlreadyRunned.foldRight(null, (alreadyRunned, previous)async{
      if(!alreadyRunned)
        await errorHandler.executeFunction(() => repository.setAppRunnedAnyTime());
    });
    return appAlreadyRunned;
  }

}