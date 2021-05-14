import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';

class GoReplacingAllTo implements UseCase<void, NavigationParams>{
  final CustomNavigator navigator;
  final NavigationRepository navRepository;

  GoReplacingAllTo({
    @required this.navigator, 
    @required this.navRepository
  });

  @override
  Future<Either<Failure, void>> call(NavigationParams params)async{
    final eitherRepository = await navRepository.replaceAllNavRoutesForNew(params.navRoute);
    //navigator.navigateReplacingTo(params.navRoute, params.arguments);
    return eitherRepository;
  }
}