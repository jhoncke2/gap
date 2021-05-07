import 'dart:convert';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango_toma.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/utils/string_to_double_converter.dart';
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
class MockStringToDoubleConverter extends Mock implements StringToDoubleConverter{}

MuestrasBloc bloc;
MockGetMuestras getMuestras;
MockSetMuestra setMuestras;
MockStringToDoubleConverter pesosConverter;

void main(){ 
  setUp((){
    setMuestras = MockSetMuestra();
    getMuestras = MockGetMuestras();
    pesosConverter = MockStringToDoubleConverter();
    bloc = MuestrasBloc(
      getMuestras: getMuestras, 
      setMuestra: setMuestras,
      pesosConverter: pesosConverter
    );
  });

  group('bloc initializatoin', (){
    Muestra tMuestra;
    setUp((){
      tMuestra = _getMuestraFromFixture();
    });

    test('bloc creation', ()async{
      expect(bloc.state, MuestraEmpty());
    });

    //TODO: Encontrar forma de testear que inicialmente se haga un auto add de getMuestra
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
      final expectedsOrderedStates = [
        LoadingMuestra(),
        OnPreparacionMuestra(muestra: tMuestra)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
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

    test('shoul yield the specified states when all goes good from onPreparacionMuestra', ()async{
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

  group('addNewTomaDeMuestra', (){
    Muestra tMuestra;
    setUp((){
      tMuestra = _getMuestraFromFixture();
      List<Componente> tMuestraComponentes = tMuestra.componentes;
      for(int i = 0; i < tMuestraComponentes.length; i++){
        tMuestraComponentes[i].preparacion = '${tMuestraComponentes[i].preparacion}_preparación';
      }
    });

    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        LoadingMuestra(),
        OnChosingRangoEdad(muestra: tMuestra)
      ];
      bloc.emit(OnEleccionTomaOFinalizar(muestra: tMuestra));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(AddNewTomaDeMuestra());
    });
  });

  group('chooseRangoEdad', (){
    Muestra tMuestra;
    String tRango;
    setUp((){
      tMuestra = _getMuestraFromFixture();
      tRango = tMuestra.rangos[0];
    });
    
    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        LoadingMuestra(),
        OnTomaPesos(muestra: tMuestra, rangoEdad: tRango)
      ];
      bloc.emit(OnChosingRangoEdad(muestra: tMuestra));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(ChooseRangoEdad(rango: tRango));
    });
  });

  group('addTomaPesosMuestra', (){
    Muestra tMuestra;
    String tRango;
    List<String> tStringPesos;
    List<double> tDoublePesos;
    Muestra tMuestraConPesosTomados;
    setUp((){
      tMuestra = _getMuestraFromFixture();
      tRango = tMuestra.rangos[0];
      tStringPesos = [];
      tDoublePesos = [];
      tMuestraConPesosTomados = _getMuestraFromFixture();
      List<Componente> tComponentes = tMuestraConPesosTomados.componentes;
      for(int i = 0; i < tComponentes.length; i++){
        RangoToma tRangoToma = tComponentes[i].valoresPorRango.singleWhere((rT) => rT.rango == tRango);
        tRangoToma.pesosTomados.add(i.toDouble());
        tStringPesos.add('$i');
        tDoublePesos.add(i.toDouble());  
      }
      bloc.emit(OnTomaPesos(muestra: tMuestra, rangoEdad: tRango));
    });

    test('should call the pesosConverter', ()async{
      when(pesosConverter.convert(any)).thenReturn(Right(tDoublePesos));
      bloc.add(AddTomaPesosMuestra(pesos: tStringPesos));
      await untilCalled(pesosConverter.convert(any));
      verify(pesosConverter.convert(tStringPesos));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(pesosConverter.convert(any)).thenReturn(Right(tDoublePesos));
      final expectedOrderedStates = [
        LoadingMuestra(),
        OnEleccionTomaOFinalizar(muestra: tMuestraConPesosTomados)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(AddTomaPesosMuestra(pesos: tStringPesos));
    });

    test('should yield the specified ordered states when converter return Left(Failure)', ()async{
      when(pesosConverter.convert(any)).thenReturn(Left(FormatFailure()));
      final expectedOrderedStates = [
        LoadingMuestra(),
        MuestraError(message: MuestrasBloc.FORMAT_PESOS_ERROR)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(AddTomaPesosMuestra(pesos: tStringPesos));
    });

  });
}

_getStatesForGetMuestras(Muestra muestra){
  return [
    LoadingMuestra(),
    OnPreparacionMuestra(muestra: muestra)
  ];
}

Muestra _getMuestraFromFixture(){
  String stringMuestra = callFixture('muestra.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  return MuestraModel.fromJson(jsonMuestra);
}