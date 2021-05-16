import 'dart:convert';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/remove_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/update_muestra.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango_toma.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/utils/string_to_double_converter.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockGetMuestras extends Mock implements GetMuestras{}
class MockSetMuestra extends Mock implements SetMuestra{}
class MockUpdateMuestra extends Mock implements UpdateMuestra{}
class MockStringToDoubleConverter extends Mock implements StringToDoubleConverter{}
class MockRemoveMuestra extends Mock implements RemoveMuestra{}

MuestrasBloc bloc;
MockGetMuestras getMuestras;
MockSetMuestra setMuestras;
MockUpdateMuestra updateMuestra;
MockRemoveMuestra removeMuestra;
MockStringToDoubleConverter pesosConverter;

void main(){ 
  setUp((){
    pesosConverter = MockStringToDoubleConverter();
    removeMuestra = MockRemoveMuestra();
    updateMuestra = MockUpdateMuestra();
    setMuestras = MockSetMuestra();
    getMuestras = MockGetMuestras(); 
    bloc = MuestrasBloc(
      getMuestras: getMuestras, 
      setMuestra: setMuestras,
      updateMuestra: updateMuestra,
      removeMuestra: removeMuestra,
      pesosConverter: pesosConverter
    );
  });

  group('bloc initialization', (){
    Muestreo tMuestra;
    setUp((){
      tMuestra = _getMuestreoFromFixture();
    });

    test('bloc creation', ()async{
      expect(bloc.state, MuestreoEmpty());
    });

    //TODO: Encontrar forma de testear que inicialmente se haga un auto add de getMuestra
  });

  group('getMuestreos', (){
    Muestreo tMuestra;
    setUp((){
      tMuestra = _getMuestreoFromFixture();
    });

    test('should call the getMuestreos usecase', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestra));
      bloc.add(GetMuestreoEvent());
      await untilCalled(getMuestras.call(any));
      verify(getMuestras.call(NoParams()));
    });

    test('should yield the specified states in order when all goes good', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestra));
      final expectedsOrderedStates = [
        LoadingMuestreo(),
        OnPreparacionMuestra(muestra: tMuestra)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(GetMuestreoEvent());
    });

    test('should yield the specified states in order when there is any problem', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Left(ServerFailure(message: 'mensajito')));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        MuestraError(message: 'mensajito')
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(GetMuestreoEvent());
    });
  });

  group('SetMuestreoPreparaciones', (){
    Muestreo tMuestra;
    List<String> tPreparaciones;
    Muestreo tMuestraConPreparaciones;
    setUp((){
      tMuestra = _getMuestreoFromFixture();
      tPreparaciones = tMuestra.componentes.map(
        (c) => 'preparacion_${c.nombre}'
      ).toList();
      tMuestraConPreparaciones = _getMuestreoFromFixture();
      List<Componente> tMuestraComponentes = tMuestraConPreparaciones.componentes;
      for(int i = 0; i < tMuestraComponentes.length; i++){
        tMuestraComponentes[i].preparacion = tPreparaciones[i];
      }
    });

    test('shoul yield the specified states when all goes good from onPreparacionMuestra', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestra));
      bloc.emit(OnPreparacionMuestra(muestra: tMuestra));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnEleccionTomaOFinalizar(muestreo: tMuestraConPreparaciones)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SetMuestreoPreparaciones(preparaciones: tPreparaciones));
    });
  });

  group('addNewMuestra', (){
    Muestreo tMuestra;
    setUp((){
      tMuestra = _getMuestreoFromFixture();
      List<Componente> tMuestraComponentes = tMuestra.componentes;
      for(int i = 0; i < tMuestraComponentes.length; i++){
        tMuestraComponentes[i].preparacion = '${tMuestraComponentes[i].preparacion}_preparación';
      }
    });

    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnChosingRangoEdad(muestreo: tMuestra)
      ];
      bloc.emit(OnEleccionTomaOFinalizar(muestreo: tMuestra));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(InitNewMuestra());
    });
  });

  group('chooseRangoEdad', (){
    Muestreo tMuestra;
    String tRango;
    int tRangoIndex;
    setUp((){
      tMuestra = _getMuestreoFromFixture();
      tRango = tMuestra.rangos[0];
      tRangoIndex = 0;
    });
    
    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnTomaPesos(muestreo: tMuestra, rangoEdadIndex: tRangoIndex)
      ];
      bloc.emit(OnChosingRangoEdad(muestreo: tMuestra));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(ChooseRangoEdad(rangoIndex: tRangoIndex));
    });
  });

  group('addMuestraPesos', (){
    Muestreo tMuestra;
    String tRango;
    int tRangoIndex;
    List<String> tStringPesos;
    List<double> tDoublePesos;
    Muestreo tMuestreoConPesosTomados;
    setUp((){
      tMuestra = _getMuestreoFromFixture();
      tRango = tMuestra.rangos[0];
      tRangoIndex = 0;
      tStringPesos = [];
      tDoublePesos = [];
      tMuestreoConPesosTomados = _getMuestreoFromFixture()..nMuestras += 1;
      List<Componente> tComponentes = tMuestreoConPesosTomados.componentes;
      for(int i = 0; i < tComponentes.length; i++){
        tStringPesos.add('$i');
        tDoublePesos.add(i.toDouble());  
      }
      tMuestreoConPesosTomados.muestrasTomadas.add(
        MuestraModel(id: 0, rango: tRango, pesos: tDoublePesos)
      );
      bloc.emit(OnTomaPesos(muestreo: tMuestra, rangoEdadIndex: tRangoIndex));
    });

    test('should call the pesosConverter', ()async{
      when(pesosConverter.convert(any)).thenReturn(Right(tDoublePesos));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreoConPesosTomados));
      bloc.add(AddMuestraPesos(pesos: tStringPesos));
      await untilCalled(pesosConverter.convert(any));
      verify(pesosConverter.convert(tStringPesos));
      await untilCalled(setMuestras.call(any));
      verify(setMuestras.call(SetMuestraParams(selectedRangoIndex: tRangoIndex, pesosTomados: tDoublePesos)));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(pesosConverter.convert(any)).thenReturn(Right(tDoublePesos));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreoConPesosTomados));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnEleccionTomaOFinalizar(muestreo: tMuestreoConPesosTomados)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(AddMuestraPesos(pesos: tStringPesos));
    });

    test('should yield the specified ordered states when converter return Left(Failure)', ()async{
      when(pesosConverter.convert(any)).thenReturn(Left(FormatFailure()));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        MuestraError(message: MuestrasBloc.FORMAT_PESOS_ERROR)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(AddMuestraPesos(pesos: tStringPesos));
    });

  });

  group('chooseMuestra', (){
    Muestreo tMuestreo;
    Muestra tMuestra;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tMuestra = tMuestreo.muestrasTomadas[0];
    });

    test('should yield the specified ordered states', ()async{
      bloc.emit(OnEleccionTomaOFinalizar(muestreo: tMuestreo));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnMuestraDetail(muestra: tMuestra, muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(ChooseMuestra(muestra: tMuestra));
    });
  });

  group('removeMuestra', (){
    Muestreo tMuestreo;
    Muestra tMuestra;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tMuestra = tMuestreo.muestrasTomadas[0];
      bloc.emit(OnMuestraDetail(muestra: tMuestra, muestreo: tMuestreo));
    });

    test('should call the specified useCase', ()async{
      when(removeMuestra.call(any)).thenAnswer((_) async => Right(null));
      bloc.add(RemoveMuestraEvent());
      await untilCalled(removeMuestra(any));
      verify(removeMuestra(RemoveMuestraParams(muestraId: tMuestra.id)));
    });
    
    test('should yield the specified ordered states', ()async{
      when(removeMuestra.call(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        MuestraRemoved(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(RemoveMuestraEvent());
    });

    test('should yield the specified ordered states', ()async{
      when(removeMuestra.call(any)).thenAnswer((_) async => Left(ServerFailure(message: 'mensajito')));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        MuestraError(message: MuestrasBloc.GENERAL_ERROR_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(RemoveMuestraEvent());
    });
  });

  group('backFromMuestraDetail', (){
    Muestreo tMuestreo;
    Muestra tMuestra;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tMuestra = tMuestreo.muestrasTomadas[0];
      bloc.emit(OnMuestraDetail(muestra: tMuestra, muestreo: tMuestreo));
    });

    test('should yield the specified ordered states', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnEleccionTomaOFinalizar(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(BackFromMuestraDetail());
    });
  });
}

Muestreo _getMuestreoFromFixture(){
  String stringMuestra = callFixture('muestra.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  return MuestreoModel.fromJson(jsonMuestra);
}