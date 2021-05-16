import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/remove_muestra.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository {}

RemoveMuestra useCase;
MockMuestrasRepository repository;

void main(){
  setUp((){
    repository = MockMuestrasRepository();
    useCase = RemoveMuestra(repository: repository);
  });

  group('call', (){
    int tMuestraId;
    setUp((){
      tMuestraId = 1;
    });

    test('should call the repository method', ()async{
      await useCase(RemoveMuestraParams(muestraId: tMuestraId));
      verify(repository.removeMuestra(tMuestraId));
    });
  });
}