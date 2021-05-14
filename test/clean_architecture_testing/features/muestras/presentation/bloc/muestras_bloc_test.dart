import 'dart:convert';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
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

  group('bloc initialization', (){
    Muestreo tMuestra;
    setUp((){
      tMuestra = _getMuestraFromFixture();
    });

    test('bloc creation', ()async{
      expect(bloc.state, MuestraEmpty());
    });

    //TODO: Encontrar forma de testear que inicialmente se haga un auto add de getMuestra
  });

  group('getMuestreos', (){
    Muestreo tMuestra;
    setUp((){
      tMuestra = _getMuestraFromFixture();
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
        LoadingMuestra(),
        OnPreparacionMuestra(muestra: tMuestra)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(GetMuestreoEvent());
    });

    test('should yield the specified states in order when there is any problem', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Left(ServerFailure(message: 'mensajito')));
      final expectedOrderedStates = [
        LoadingMuestra(),
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
      bloc.add(SetMuestreoPreparaciones(preparaciones: tPreparaciones));
    });
  });

  group('addNewMuestra', (){
    Muestreo tMuestra;
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
      bloc.add(InitNewMuestra());
    });
  });

  group('chooseRangoEdad', (){
    Muestreo tMuestra;
    String tRango;
    int tRangoIndex;
    setUp((){
      tMuestra = _getMuestraFromFixture();
      tRango = tMuestra.rangos[0];
      tRangoIndex = 0;
    });
    
    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        LoadingMuestra(),
        OnTomaPesos(muestra: tMuestra, rangoEdadIndex: tRangoIndex)
      ];
      bloc.emit(OnChosingRangoEdad(muestra: tMuestra));
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
      tMuestra = _getMuestraFromFixture();
      tRango = tMuestra.rangos[0];
      tRangoIndex = 0;
      tStringPesos = [];
      tDoublePesos = [];
      tMuestreoConPesosTomados = _getMuestraFromFixture()..nMuestras += 1;
      List<Componente> tComponentes = tMuestreoConPesosTomados.componentes;
      
      for(int i = 0; i < tComponentes.length; i++){
        RangoToma tRangoToma = tComponentes[i].valoresPorRango.singleWhere((rT) => rT.rango == tRango);
        tRangoToma.pesosTomados.add(i.toDouble());
        tStringPesos.add('$i');
        tDoublePesos.add(i.toDouble());  
      }
      tMuestreoConPesosTomados.muestrasTomadas.add(
        MuestraModel(rango: tRango, pesos: tDoublePesos)
      );
      bloc.emit(OnTomaPesos(muestra: tMuestra, rangoEdadIndex: tRangoIndex));
    });

    test('should call the pesosConverter', ()async{
      when(pesosConverter.convert(any)).thenReturn(Right(tDoublePesos));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreoConPesosTomados));
      bloc.add(AddMuestraPesos(pesos: tStringPesos));
      await untilCalled(pesosConverter.convert(any));
      verify(pesosConverter.convert(tStringPesos));
      await untilCalled(setMuestras.call(any));
      verify(setMuestras.call(MuestrasParams(selectedRangoIndex: tRangoIndex, pesosTomados: tDoublePesos)));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(pesosConverter.convert(any)).thenReturn(Right(tDoublePesos));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreoConPesosTomados));
      final expectedOrderedStates = [
        LoadingMuestra(),
        OnEleccionTomaOFinalizar(muestra: tMuestreoConPesosTomados)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(AddMuestraPesos(pesos: tStringPesos));
    });

    test('should yield the specified ordered states when converter return Left(Failure)', ()async{
      when(pesosConverter.convert(any)).thenReturn(Left(FormatFailure()));
      final expectedOrderedStates = [
        LoadingMuestra(),
        MuestraError(message: MuestrasBloc.FORMAT_PESOS_ERROR)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(AddMuestraPesos(pesos: tStringPesos));
    });

  });
}

_getStatesForGetMuestras(Muestreo muestra){
  return [
    LoadingMuestra(),
    OnPreparacionMuestra(muestra: muestra)
  ];
}

Muestreo _getMuestraFromFixture(){
  String stringMuestra = callFixture('muestra.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  return MuestreoModel.fromJson(jsonMuestra);
}