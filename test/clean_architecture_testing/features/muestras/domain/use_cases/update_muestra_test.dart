import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/update_muestra.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository{}

UpdateMuestra useCase;
MockMuestrasRepository repository;

void main(){
  setUp((){
    repository = MockMuestrasRepository();
    useCase = UpdateMuestra(repository: repository);
  });

  group('call', (){
    int tMuestraIndexEnMuestreo;
    List<double> tPesosTomados;
    setUp((){
      tMuestraIndexEnMuestreo = 0;
      tPesosTomados = [1.0, 2.0, 3.3, 4.5];
    });

    test('should call the repository method', ()async{
      when(repository.updateMuestra(any, any)).thenAnswer((_) async => Right(null));
      await useCase(UpdateMuestraParams(
        muestraIndexEnMuestreo: tMuestraIndexEnMuestreo,
        pesosTomados: tPesosTomados
      ));
      verify(repository.updateMuestra(tMuestraIndexEnMuestreo, tPesosTomados));
    });
  });
}