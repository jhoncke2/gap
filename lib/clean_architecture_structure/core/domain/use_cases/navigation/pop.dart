import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';

class Pop implements UseCase<void, NoParams>{

  final CustomNavigator navigator;
  final NavigationRepository navRepository;

  Pop({
    @required this.navigator, 
    @required this.navRepository
  });

  @override
  Future<Either<Failure, void>> call(NoParams params)async{
    final eitherPop = await navRepository.pop();
    if(eitherPop.isLeft())
      return eitherPop;
    final eitherCurrentRoute = await navRepository.getCurrentRoute();
    return eitherCurrentRoute.fold((l){
      return Left(l);
    }, (navRoute){
      navigator.navigateReplacingTo(navRoute);
      return Right(null);
    });
  }
}