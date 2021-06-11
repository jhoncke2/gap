import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/end_muestreo.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository {}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler {}

EndMuestreo useCase;
MockMuestrasRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockMuestrasRepository();
    useCase = EndMuestreo(
      repository: repository, 
      errorHandler: errorHandler
    );
  });

  test('should call the specified methods', ()async{
    when(errorHandler.executeFunction<void>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(repository.endMuestreo()).thenAnswer((_) async => Right(null));
    await useCase(NoParams());
    verify(errorHandler.executeFunction<void>(any));
    verify(repository.endMuestreo());
  });

  test('should return the repository returned value', ()async{
    when(errorHandler.executeFunction<void>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(repository.endMuestreo()).thenAnswer((_) async => Right(null));
    final result = await useCase(NoParams());
    expect(result, Right(null));
  });
}