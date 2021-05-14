import 'dart:async';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango_toma.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/utils/string_to_double_converter.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';

part 'muestras_event.dart';
part 'muestras_state.dart';

class MuestrasBloc extends Bloc<MuestrasEvent, MuestrasState>{
  static const GENERAL_ERROR_MESSAGE = 'Ocurrió un error inesperado';
  static const FORMAT_PESOS_ERROR = 'Hay un problema con el formato de los pesos';

  final GetMuestras getMuestras;
  final SetMuestra setMuestra;
  final StringToDoubleConverter pesosConverter;
  MuestrasBloc({
    @required this.getMuestras,
    @required this.setMuestra,
    @required this.pesosConverter
  }) : super(MuestraEmpty()){
    //add(GetMuestraEvent());
  }

  @override
  Stream<MuestrasState> mapEventToState(
    MuestrasEvent event,
  ) async* {
    if(event is GetMuestreoEvent){
      yield * _getMuestra(event);
    }else if(event is SetMuestreoPreparaciones){
      yield * _setMuestraPreparaciones(event);
    }else if(event is InitNewMuestra){
      yield * _addNewTomaDeMuestra(event);
    }else if(event is ChooseRangoEdad){
      yield * _chooseRangoEdad(event);
    }else if(event is AddMuestraPesos){
      yield * _addMuestraPesos(event);
    }
  }

  Stream<MuestrasState> _getMuestra(GetMuestreoEvent event)async*{
    yield LoadingMuestra();
    final eitherMuestras = await getMuestras(NoParams());
    yield * eitherMuestras.fold((failure)async*{
      String message = (failure is ServerFailure)? failure.message : GENERAL_ERROR_MESSAGE;
      yield MuestraError(message: message);
    }, (muestra)async*{
      yield OnPreparacionMuestra(
        muestra: muestra
      );
    });
  }

  Stream<MuestrasState> _setMuestraPreparaciones(SetMuestreoPreparaciones event)async*{
    final List<String> preparaciones = event.preparaciones;
    final Muestreo muestra =  (state as OnPreparacionMuestra).muestra;
    yield LoadingMuestra();
    final List<Componente> componentes = muestra.componentes;
    for(int i = 0; i < componentes.length; i++){
      componentes[i].preparacion = preparaciones[i];
    }
    yield OnEleccionTomaOFinalizar(muestra: muestra);
  }

  Stream<MuestrasState> _addNewTomaDeMuestra(InitNewMuestra event)async*{
    final Muestreo muestra = (state as OnEleccionTomaOFinalizar).muestra;
    yield LoadingMuestra();
    yield OnChosingRangoEdad(muestra: muestra);
  }

  Stream<MuestrasState> _chooseRangoEdad(ChooseRangoEdad event)async*{
    final Muestreo muestra = (state as OnChosingRangoEdad).muestra;
    yield LoadingMuestra();
    yield OnTomaPesos(muestra: muestra, rangoEdadIndex: event.rangoIndex);
  }

  Stream<MuestrasState> _addMuestraPesos(AddMuestraPesos event)async*{
    final Muestreo muestreo = (state as OnTomaPesos).muestra;
    final int rangoIndex = (state as OnTomaPesos).rangoEdadIndex;
    yield LoadingMuestra();
    final List<String> stringPesos = event.pesos;
    final eitherPesos = pesosConverter.convert(stringPesos);
    yield * eitherPesos.fold((_)async*{
      yield MuestraError(message: FORMAT_PESOS_ERROR);
    }, (pesos)async*{
      //TODO: Implementar usecase
      muestreo.nMuestras += 1;
      for(int i = 0; i < pesos.length; i++){
        final Componente componente = muestreo.componentes[i];
        final RangoToma rangoToma = componente.valoresPorRango.singleWhere((rT) => rT.rango == muestreo.rangos[rangoIndex]);
        rangoToma.pesosTomados.add(pesos[i]);
      }
      await setMuestra(MuestrasParams(selectedRangoIndex: rangoIndex, pesosTomados: pesos));
      final eitherMuestreo = await getMuestras(NoParams());
      yield * eitherMuestreo.fold((l)async*{
        yield MuestraError(message: GENERAL_ERROR_MESSAGE);
      }, (muestreo)async*{
        yield OnEleccionTomaOFinalizar(muestra: muestreo);
      });
      
    });
  }
}
