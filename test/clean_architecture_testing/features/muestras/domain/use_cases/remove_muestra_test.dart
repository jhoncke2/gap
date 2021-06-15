import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/remove_muestra.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository {}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler {}

RemoveMuestra useCase;
MockMuestrasRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockMuestrasRepository();
    useCase = RemoveMuestra(repository: repository, errorHandler: errorHandler);
  });

  group('call', (){
    int tMuestraId;
    setUp((){
      tMuestraId = 1;
    });

    test('should call the repository method', ()async{
      when(errorHandler.executeFunction<void>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
      await useCase(RemoveMuestraParams(muestraId: tMuestraId));
      verify(errorHandler.executeFunction<void>(any));
      verify(repository.removeMuestra(tMuestraId));
    });
  });
}