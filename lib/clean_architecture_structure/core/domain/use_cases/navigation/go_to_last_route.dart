import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';

import '../../helpers/use_case_error_handler.dart';

class GoToLastRoute implements UseCase<void, NoParams>{
  final CustomNavigator navigator;
  final NavigationRepository navRepository;
  GoToLastRoute({
    @required this.navigator, 
    @required this.navRepository
  });

  @override
  Future<Either<Failure, void>> call(NoParams params)async{
    final eitherCurrentNavRoute = await navRepository.getCurrentRoute();
    return eitherCurrentNavRoute.fold((failure){
      return Left(failure);
    }, (navRoute){
      navigator.navigateReplacingTo(navRoute);
      return Right(null);
    });
  }
}