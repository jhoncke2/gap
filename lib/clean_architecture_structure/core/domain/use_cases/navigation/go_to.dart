import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';


class GoTo implements UseCase<void, NavigationParams>{

  final CustomNavigator navigator;
  final NavigationRepository navRepository;

  GoTo({
    @required this.navigator,
    @required this.navRepository
  });

  @override
  Future<Either<Failure, void>> call(NavigationParams params)async{
    //await navigator.navigateReplacingTo(params.navRoute, params.arguments);
    return await navRepository.setNavRoute(params.navRoute);
  }
}

class NavigationParams extends Equatable{
  final NavigationRoute navRoute;
  final dynamic arguments;

  NavigationParams({
    @required this.navRoute,
    this.arguments
  });

  @override
  List<Object> get props =>[this.navRoute.value];
}