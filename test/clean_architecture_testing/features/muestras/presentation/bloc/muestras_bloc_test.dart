import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockGetMuestras extends Mock implements GetMuestras{}
class MockSetMuestra extends Mock implements SetMuestra{}

MuestrasBloc bloc;
MockGetMuestras getMuestras;
MockSetMuestra setMuestras;

void main(){
  setUp((){
    setMuestras = MockSetMuestra();
    getMuestras = MockGetMuestras();
    bloc = MuestrasBloc(
      getMuestras: getMuestras, 
      setMuestra: setMuestras
    );
  });

  group('getMuestras', (){
    Muestra tMuestra;
    setUp((){
      tMuestra = _getMuestraFromFixture();
    });

    test('should call the getMuestras usecase', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestra));
      bloc.add(GetMuestraEvent());
      await untilCalled(getMuestras.call(any));
      verify(getMuestras.call(NoParams()));
    });

    test('should yield the specified states in order when all goes good', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestra));
      final expectedOrderedStates = [
        LoadingMuestra(),
        OnPreparacionMuestra(muestra: tMuestra)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(GetMuestraEvent());
    });

    test('should yield the specified states in order when there is any problem', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Left(ServerFailure(message: 'mensajito')));
      final expectedOrderedStates = [
        LoadingMuestra(),
        MuestraError(message: 'mensajito')
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(GetMuestraEvent());
    });
  });

  group('SetMuestraPreparaciones', (){
    Muestra tMuestra;
    List<String> tPreparaciones;
    Muestra tMuestraConPreparaciones;
    setUp((){
      tMuestra = _getMuestraFromFixture();
      tPreparaciones = tMuestra.componentes.map(
        (c) => 'preparacion_${c.nombre}'
      ).toList();
      tMuestraConPreparaciones = _getMuestraFromFixture();
      List<Componente> tMuestraComponentes = tMuestraConPreparaciones.componentes;
      for(int i = 0; i < tMuestraComponentes.length; i++){
        tMuestraComponentes[i].preparacion = tPreparaciones[i];
      }
    });

    test('shoul yield the specified states when all goes good', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestra));
      bloc.emit(OnPreparacionMuestra(muestra: tMuestra));
      final expectedOrderedStates = [
        LoadingMuestra(),
        OnEleccionTomaOFinalizar(muestra: tMuestraConPreparaciones)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SetMuestraPreparaciones(preparaciones: tPreparaciones));
    });
  });
}

Muestra _getMuestraFromFixture(){
  String stringMuestra = callFixture('muestra.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  return MuestraModel.fromJson(jsonMuestra);
}