import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/save_formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_formulario.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/remove_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/update_preparaciones.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/utils/string_to_double_converter.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSetMuestra extends Mock implements SetMuestra{}
class MockGetMuestras extends Mock implements GetMuestras{}
class MockRemoveMuestra extends Mock implements RemoveMuestra{}
class MockSaveFormulario extends Mock implements SaveFormulario{}
class MockUpdatePreparaciones extends Mock implements UpdatePreparaciones{}
class MockStringToDoubleConverter extends Mock implements StringToDoubleConverter{}

MuestrasBloc bloc;
MockGetMuestras getMuestras;
MockSetMuestra setMuestras;
MockUpdatePreparaciones updatePreparaciones;
MockRemoveMuestra removeMuestra;
MockSaveFormulario saveFormulario;
MockStringToDoubleConverter pesosConverter;

void main(){ 
  setUp((){
    pesosConverter = MockStringToDoubleConverter();
    saveFormulario = MockSaveFormulario();
    removeMuestra = MockRemoveMuestra();
    updatePreparaciones = MockUpdatePreparaciones();
    setMuestras = MockSetMuestra();
    getMuestras = MockGetMuestras(); 
    bloc = MuestrasBloc(
      getMuestras: getMuestras, 
      setMuestra: setMuestras,
      updatePreparaciones: updatePreparaciones,
      removeMuestra: removeMuestra,
      pesosConverter: pesosConverter,
      saveFormulario: saveFormulario
    );
  });

  group('bloc initialization', (){
    Muestreo tMuestra;
    setUp((){
      tMuestra = _getMuestreoFromFixture();
    });

    test('bloc creation', ()async{
      expect(bloc.state, OnMuestreoEmpty());
    });

    //TODO: Encontrar forma de testear que inicialmente se haga un auto add de getMuestra
  });

  group('initMuestreo', (){
    Muestreo tMuestreo;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
    });
    
    test('should yield the specified ordered states when there is initialFormularioId', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        LoadingMuestreo(),
        LoadingFormulario(),
        LoadedInitialFormulario(muestreo: tMuestreo, formulario: tMuestreo.preFormulario)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(InitMuestreoEvent());
    });

    test('''should yield the specified ordered states when there is not initialFormularioId but yes componentes
    and muestreo has created muestras''', ()async{
      tMuestreo = _getMuestreoFromFixtureWithNullFields(['pre_formulario']);
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        LoadingMuestreo(),
        //OnPreparacionMuestreo(muestreo: tMuestreo)
        OnChooseAddMuestraOFinalizar(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(InitMuestreoEvent());
    });

    test('''should call the specified useCase 
    when there is neither initialFormularioId nor componentes but yes finalFormularioId''', ()async{
      Formulario tFormulario = _getFormularioFromxFixture();
      tMuestreo = _getMuestreoFromFixtureWithNullFields(['pre_formulario', 'componentes']);
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      bloc.add(InitMuestreoEvent());
      //await untilCalled(getFormulario.call(any));
      //verify(getFormulario(MuestreoFormularioParams(formularioId: tMuestreo.formularioFinalId)));
    });

    test('''should yield the specified ordered states 
    when there is neither initialFormularioId nor componentes but yes finalFormularioId''', ()async{
      tMuestreo = _getMuestreoFromFixtureWithNullFields(['pre_formulario', 'componentes']);
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        LoadingMuestreo(),
        LoadingFormulario(),
        LoadedFinalFormulario(muestreo: tMuestreo, formulario: tMuestreo.posFormulario)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(InitMuestreoEvent());
    });

    test('''should yield the specified ordered states 
    neither initialFormularioId nor componentes nor finalFormularioId''', ()async{
      tMuestreo = _getMuestreoFromFixtureWithNullFields(['pre_formulario', 'componentes', 'pos_formulario']);
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        LoadingMuestreo(),
        MuestreoFinished(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(InitMuestreoEvent());
    });
  });

  group('EndInitialFormulario', (){
    Muestreo tMuestreo;
    Formulario tFormulario;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tFormulario = _getFormularioFromxFixture();
    });

    test('should call the specified useCase', ()async{
      
      bloc.emit(LoadedInitialFormulario(formulario: tFormulario, muestreo: tMuestreo));
      bloc.add(EndInitialFormulario(formulario: tFormulario));
      await untilCalled(saveFormulario(any));
      verify(saveFormulario( SaveFormularioParams(muestreoId: tMuestreo.id, formulario: tFormulario, formularioType: MuestrasBloc.PRE_FORMULARIO_TYPE)));  
    });

    test('should yield the specified states in order when all goes good and there is muestras components', ()async{
      bloc.emit(LoadedInitialFormulario(formulario: tFormulario, muestreo: tMuestreo));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        LoadingFormulario(),
        OnChooseAddMuestraOFinalizar(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(EndInitialFormulario(formulario: tFormulario));
    });

    test('should yield the specified states in order when all goes good and there is not muestras', ()async{
      tMuestreo = _getMuestreoFromFixtureWithNullFields(['muestras']);
      bloc.emit(LoadedInitialFormulario(formulario: tFormulario, muestreo: tMuestreo));
      
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        LoadingFormulario(),
        OnPreparacionMuestreo(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(EndInitialFormulario(formulario: tFormulario));
    });

    test('''should yield the specified states in order when all goes good 
    and there is not componentes and there is formulario final''', ()async{
      tMuestreo = _getMuestreoFromFixtureWithNullFields(['componentes']);
      bloc.emit(LoadedInitialFormulario(formulario: tFormulario, muestreo: tMuestreo));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        LoadingFormulario(),
        LoadedFinalFormulario(muestreo: tMuestreo, formulario: tMuestreo.posFormulario)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(EndInitialFormulario(formulario: tFormulario));
    });

    test('''should yield the specified states in order when all goes good 
    and there is not componentes and there is not formulario final''', ()async{
      tMuestreo = _getMuestreoFromFixtureWithNullFields(['componentes', 'pos_formulario']);
      bloc.emit(LoadedInitialFormulario(formulario: tFormulario, muestreo: tMuestreo));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        LoadingFormulario(),
        MuestreoFinished(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(EndInitialFormulario(formulario: tFormulario));
    });
  });

  group('endTomaMuestras', (){
    Muestreo tMuestreo;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
    });
    
    test('should yield the specified states in order when all goes good and there is finalFormularioId', ()async{
      bloc.emit(OnChooseAddMuestraOFinalizar(muestreo: tMuestreo));
      final expectedsOrderedStates = [
        LoadingFormulario(),
        LoadedFinalFormulario(muestreo: tMuestreo, formulario: tMuestreo.posFormulario)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(EndTomaMuestras());
    });

    test('should yield the specified states in order when all goes good and there is not finalFormularioId', ()async{
      tMuestreo = _getMuestreoFromFixtureWithNullFields(['pos_formulario']);
      bloc.emit(OnChooseAddMuestraOFinalizar(muestreo: tMuestreo));
      final expectedsOrderedStates = [
        MuestreoFinished(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(EndTomaMuestras());
    });
  });

  group('endFinalFormulario', (){
    Muestreo tMuestreo;
    Formulario tFormulario;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tFormulario = _getFormularioFromxFixture();
      when(saveFormulario.call(any)).thenAnswer((_) async => Right(null));
    });

    test('should call the specified useCase when all goes good', ()async{
      bloc.emit(LoadedFinalFormulario(muestreo: tMuestreo, formulario: tFormulario));
      bloc.add(EndFinalFormulario(formulario: tFormulario));
      await untilCalled(saveFormulario(any));
      verify(saveFormulario(SaveFormularioParams(muestreoId: tMuestreo.id, formulario: tFormulario, formularioType: MuestrasBloc.POS_FORMULARIO_TYPE)));
    });

    test('should yield the specified states in order when all goes good', ()async{
      bloc.emit(LoadedFinalFormulario(muestreo: tMuestreo, formulario: tFormulario));
      final expectedsOrderedStates = [
        LoadingFormulario(),
        MuestreoFinished(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(EndFinalFormulario(formulario: tFormulario));
    });
  });

  group('initTomaMuestras', (){
    Muestreo tMuestreo;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      bloc.emit(OnChooseMuestreoStep(muestreo: tMuestreo));
    });

    test('should yield the specified states in order when all goes good', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreo));
      final expectedsOrderedStates = [
        OnPreparacionMuestreo(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedsOrderedStates));
      bloc.add(InitTomaMuestras());
    });

    test('should yield the specified states in order when there is any problem', ()async{
      when(getMuestras.call(any)).thenAnswer((_) async => Left(ServerFailure(message: 'mensajito')));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        MuestraError(message: 'mensajito')
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(InitMuestreoEvent());
    });
  });

  group('SetMuestreoPreparaciones', (){
    Muestreo tMuestreo;
    List<String> tPreparaciones;
    Muestreo tMuestreoConPreparaciones;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tPreparaciones = tMuestreo.componentes.map(
        (c) => 'preparacion_${c.nombre}'
      ).toList();
      tMuestreoConPreparaciones = _getMuestreoFromFixture();
      List<Componente> tMuestraComponentes = tMuestreoConPreparaciones.componentes;
      for(int i = 0; i < tMuestraComponentes.length; i++){
        tMuestraComponentes[i].preparacion = tPreparaciones[i];
      }
      bloc.emit(OnPreparacionMuestreo(muestreo: tMuestreo));
      when(updatePreparaciones.call(any)).thenAnswer((_) async => Right(null));
    });

    test('should call the specified useCases', ()async{
      bloc.add(SetMuestreoPreparaciones(preparaciones: tPreparaciones));
      await untilCalled(updatePreparaciones(any));
      verify(updatePreparaciones(UpdatePreparacionesParams(muestreoId: tMuestreo.id, preparaciones: tPreparaciones)));
    });

    test('shoul yield the specified states when all goes good from onPreparacionMuestra', ()async{
      final expectedOrderedStates = [
        LoadingMuestreo(),
        //OnChooseAddMuestraOFinalizar(muestreo: tMuestraConPreparaciones)
        OnChooseRangosAUsar(muestreo: tMuestreoConPreparaciones)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SetMuestreoPreparaciones(preparaciones: tPreparaciones));
    });
  });

  group('chooseRangosAUsar', (){
    Muestreo tMuestreo;
    List<Rango> tRangosAUsar;
    Muestreo tMuestreoWithNewRangos;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tRangosAUsar = tMuestreo.rangos.sublist(0, 1);
      bloc.emit(OnChooseRangosAUsar(muestreo: tMuestreo));
      tMuestreoWithNewRangos = _getMuestreoFromFixture().copyWith(rangos: tRangosAUsar);
    });

    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnChooseAddMuestraOFinalizar(muestreo: tMuestreoWithNewRangos)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(ChooseRangosAUsar(rangos: tRangosAUsar));
    });
  });

  group('addNewMuestra', (){
    Muestreo tMuestreo;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      List<Componente> tMuestraComponentes = tMuestreo.componentes;
      for(int i = 0; i < tMuestraComponentes.length; i++){
        tMuestraComponentes[i].preparacion = '${tMuestraComponentes[i].preparacion}_preparación';
      }
    });

    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnChosingRangoEdad(muestreo: tMuestreo)
      ];
      bloc.emit(OnChooseAddMuestraOFinalizar(muestreo: tMuestreo));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(InitNewMuestra());
    });
  });

  group('chooseRangoEdad', (){
    Muestreo tMuestreo;
    int tRangoId;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tRangoId = 0;
    });
    
    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnTomaPesos(muestreo: tMuestreo, rangoId: tRangoId)
      ];
      bloc.emit(OnChosingRangoEdad(muestreo: tMuestreo));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(ChooseRangoEdad(rangoId: tRangoId));
    });
  });

  group('addMuestraPesos', (){
    Muestreo tMuestreo;
    int tRangoId;
    String tStringRango;
    List<String> tStringPesos;
    List<double> tDoublePesos;
    Muestreo tMuestreoConPesosTomados;
    setUp((){
      tMuestreo = _getMuestreoFromFixture();
      tRangoId = 1;
      tStringRango = tMuestreo.rangos.singleWhere((r) => r.id == tRangoId).nombre;      
      tStringPesos = [];
      tDoublePesos = [];
      tMuestreoConPesosTomados = _getMuestreoFromFixture();
      tMuestreoConPesosTomados = tMuestreoConPesosTomados.copyWith(nMuestras: tMuestreoConPesosTomados.nMuestras + 1);
      List<Componente> tComponentes = tMuestreoConPesosTomados.componentes;
      for(int i = 0; i < tComponentes.length; i++){
        tStringPesos.add('$i');
        tDoublePesos.add(i.toDouble());  
      }
      tMuestreoConPesosTomados.muestrasTomadas.add(
        MuestraModel(id: 0, rango: tStringRango, pesos: tDoublePesos)
      );
      bloc.emit(OnTomaPesos(muestreo: tMuestreo, rangoId: tRangoId));
    });

    test('should call the pesosConverter and the setMuestras useCase', ()async{
      when(pesosConverter.convert(any)).thenReturn(Right(tDoublePesos));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreoConPesosTomados));
      bloc.add(AddMuestraPesos(pesos: tStringPesos));
      await untilCalled(pesosConverter.convert(any));
      verify(pesosConverter.convert(tStringPesos));
      await untilCalled(setMuestras.call(any));
      verify(setMuestras.call(SetMuestraParams(muestreoId: tMuestreo.id, selectedRangoId: tRangoId, pesosTomados: tDoublePesos)));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(pesosConverter.convert(any)).thenReturn(Right(tDoublePesos));
      when(getMuestras.call(any)).thenAnswer((_) async => Right(tMuestreoConPesosTomados));
      final expectedOrderedStates = [
        LoadingMuestreo(),
        OnChooseAddMuestraOFinalizar(muestreo: tMuestreoConPesosTomados)
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
      bloc.emit(OnChooseAddMuestraOFinalizar(muestreo: tMuestreo));
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
        OnChooseAddMuestraOFinalizar(muestreo: tMuestreo)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(BackFromMuestraDetail());
    });
  });
}

Muestreo _getMuestreoFromFixture(){
  String stringMuestra = callFixture('muestreo.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  return MuestreoModel.fromRemoteJson(jsonMuestra);
}

Muestreo _getMuestreoFromFixtureWithNullFields(List<String> fields){
  String stringMuestra = callFixture('muestreo.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  fields.forEach((f) {
    jsonMuestra[f] = null;
  });
  return MuestreoModel.fromRemoteJson(jsonMuestra);
}

Formulario _getFormularioFromxFixture(){
  final String stringFs = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonFs = jsonDecode(stringFs).cast<Map<String, dynamic>>();
  return FormularioModel.fromJson(jsonFs[0]);
}