import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';

import '../../helpers/use_case_error_handler.dart';

class Pop implements UseCase<NavigationRoute, NoParams>{

  final CustomNavigator navigator;
  final NavigationRepository navRepository;
  final UseCaseErrorHandler errorHandler;
  Pop({
    @required this.navigator, 
    @required this.navRepository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, NavigationRoute>> call(NoParams params)async{
    final eitherErrHandler = await errorHandler.executeFunction<NavigationRoute>(
      ()async{
        final eitherPop = await navRepository.pop();
        if(eitherPop.isLeft())
          return eitherPop.fold((l) => Left(l), (r) => Right(null));
        return await navRepository.getCurrentRoute();
      }
    );
    return eitherErrHandler.fold((l){
      return Left(l);
    }, (navRoute){
      return Right(navRoute);
    });
  }
}