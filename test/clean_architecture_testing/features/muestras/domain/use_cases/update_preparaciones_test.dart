import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/update_preparaciones.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository{}

UpdatePreparaciones useCase;
MockMuestrasRepository repository;

void main(){
  setUp((){
    repository = MockMuestrasRepository();
    useCase = UpdatePreparaciones(repository: repository);
  });

  group('call', (){
    int tMuestreoId;
    List<String> tPreparaciones;
    setUp((){
      tMuestreoId = 1;
      tPreparaciones = ['prep1', 'prep2', 'prep3'];
    });

    test('should call the repository method', ()async{
      when(repository.updatePreparaciones(any, any)).thenAnswer((_) async => Right(null));
      await useCase(UpdatePreparacionesParams(
        muestreoId: tMuestreoId,
        preparaciones: tPreparaciones
      ));
      verify(repository.updatePreparaciones(tMuestreoId, tPreparaciones));
    });
  });
}