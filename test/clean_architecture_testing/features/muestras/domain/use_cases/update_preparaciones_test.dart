import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/update_preparaciones.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

UpdatePreparaciones useCase;
MockMuestrasRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockMuestrasRepository();
    useCase = UpdatePreparaciones(repository: repository, errorHandler: errorHandler);
  });

  group('call', (){
    int tMuestreoId;
    List<String> tPreparaciones;
    setUp((){
      tMuestreoId = 1;
      tPreparaciones = ['prep1', 'prep2', 'prep3'];
    });

    test('should call the repository method', ()async{
      when(errorHandler.executeFunction<void>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
      when(repository.updatePreparaciones(any, any)).thenAnswer((_) async => Right(null));
      await useCase(UpdatePreparacionesParams(
        muestreoId: tMuestreoId,
        preparaciones: tPreparaciones
      ));
      verify(errorHandler.executeFunction<void>(any));
      verify(repository.updatePreparaciones(tMuestreoId, tPreparaciones));
    });
  });
}