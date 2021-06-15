import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/features/init/domain/use_cases/get_app_already_runned.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockCentralSystemRepository extends Mock implements CentralSystemRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GetAppAlreadyRunned useCase;
MockCentralSystemRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    repository = MockCentralSystemRepository();
    errorHandler = MockUseCaseErrorHandler();
    useCase = GetAppAlreadyRunned(repository: repository, errorHandler: errorHandler);
    when(errorHandler.executeFunction<bool>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
  });

  test('should call the specified methods', ()async{
    when(repository.getAppRunnedAnyTime()).thenAnswer((_) async=> Right(true));
    await useCase(NoParams());
    verify(errorHandler.executeFunction<bool>(any));
    verify(repository.getAppRunnedAnyTime());
    verifyNever(repository.setAppRunnedAnyTime());
  });

  test('should return the getAppRunnedAnyTime() returned result as Right(true)', ()async{
    when(repository.getAppRunnedAnyTime()).thenAnswer((_) async=> Right(true));
    final result = await useCase(NoParams());
    expect(result, Right(true));
  });

  test('should call the specified methods', ()async{
    when(repository.getAppRunnedAnyTime()).thenAnswer((_) async=> Right(false));
    await useCase(NoParams());
    verify(errorHandler.executeFunction<bool>(any)).called(2);
    verify(repository.getAppRunnedAnyTime());
    verify(repository.setAppRunnedAnyTime());
  });

  test('should return the getAppRunnedAnyTime() returned result as Right(true)', ()async{
    when(repository.getAppRunnedAnyTime()).thenAnswer((_) async=> Right(false));
    final result = await useCase(NoParams());
    expect(result, Right(false));
  });
}