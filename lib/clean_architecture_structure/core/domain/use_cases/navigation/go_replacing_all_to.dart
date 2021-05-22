import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';

import '../use_case_error_handler.dart';

class GoReplacingAllTo implements UseCase<void, NavigationParams>{
  final CustomNavigator navigator;
  final NavigationRepository navRepository;
  final UseCaseErrorHandler errorHandler;

  GoReplacingAllTo({
    @required this.navigator, 
    @required this.navRepository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(NavigationParams params)async{
    return await errorHandler.executeFunction<void>(
      () async => await navRepository.replaceAllNavRoutesForNew(params.navRoute)
    );
  }
}