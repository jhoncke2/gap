import 'dart:async';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/remove_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/update_preparaciones.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/utils/string_to_double_converter.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';

part 'muestras_event.dart';
part 'muestras_state.dart';

class MuestrasBloc extends Bloc<MuestrasEvent, MuestrasState>{
  static const GENERAL_ERROR_MESSAGE = 'Ha ocurrido un error';
  static const FORMAT_PESOS_ERROR = 'Hay un problema con el formato de los pesos';

  final GetMuestras getMuestras;
  final SetMuestra setMuestra;
  final UpdatePreparaciones updatePreparaciones;
  final RemoveMuestra removeMuestra;
  final StringToDoubleConverter pesosConverter;

  MuestrasBloc({
    @required this.getMuestras,
    @required this.setMuestra,
    @required this.updatePreparaciones,
    @required this.removeMuestra,
    @required this.pesosConverter
  }) : super(MuestreoEmpty()){
    //add(GetMuestraEvent());
  }

  @override
  Stream<MuestrasState> mapEventToState(
    MuestrasEvent event,
  ) async* {
    if(event is GetMuestreoEvent){
      yield * _getMuestra(event);
    }else if(event is SetMuestreoPreparaciones){
      yield * _setMuestreoPreparaciones(event);
    }else if(event is ChooseRangosAUsar){
      yield * _chooseRangosAUsar(event);
    }else if(event is InitNewMuestra){
      yield * _addNewTomaDeMuestra(event);
    }else if(event is ChooseRangoEdad){
      yield * _chooseRangoEdad(event);
    }else if(event is AddMuestraPesos){
      yield * _addMuestraPesos(event);
    }else if(event is InitMuestraEditing){
      yield * _initMuestraEdigint(event);
    }else if(event is ChooseMuestra){
      yield * _chooseMuestra(event);
    }else if(event is RemoveMuestraEvent){
      yield * _removeMuestra();
    }else if(event is BackFromMuestraDetail){
      yield * _backFromMuestraDetail();
    }
  }

  Stream<MuestrasState> _getMuestra(GetMuestreoEvent event)async*{
    yield LoadingMuestreo();
    final eitherMuestreo = await getMuestras(NoParams());
    yield * eitherMuestreo.fold((failure)async*{
      String message = (failure is ServerFailure)? failure.message : GENERAL_ERROR_MESSAGE;
      yield MuestraError(message: message);
    }, (muestreo)async*{
      yield OnPreparacionMuestra(
        muestreo: muestreo
      );
    });
  }

  Stream<MuestrasState> _setMuestreoPreparaciones(SetMuestreoPreparaciones event)async*{
    final Muestreo muestreo =  (state as OnPreparacionMuestra).muestreo;
    yield LoadingMuestreo();
    final List<String> preparaciones = event.preparaciones;
    final eitherUpdatePreparaciones = await updatePreparaciones(UpdatePreparacionesParams(muestreoId: muestreo.id, preparaciones: preparaciones));
    yield * eitherUpdatePreparaciones.fold((_)async*{
      yield MuestraError(message: GENERAL_ERROR_MESSAGE);
    }, (r)async*{
      final List<Componente> componentes = muestreo.componentes;
      for(int i = 0; i < componentes.length; i++){
        componentes[i].preparacion = preparaciones[i];
      }
      yield OnChooseRangosAUsar(muestreo: muestreo);
    });
  }

  Stream<MuestrasState> _chooseRangosAUsar(ChooseRangosAUsar event)async*{
    Muestreo muestreo = (state as LoadedMuestreo).muestreo;
    yield LoadingMuestreo();
    muestreo = muestreo.copyWith(rangos: event.rangos);
    yield OnChooseAddMuestraOFinalizar(muestreo: muestreo);
  }

  Stream<MuestrasState> _addNewTomaDeMuestra(InitNewMuestra event)async*{
    final Muestreo muestra = (state as OnChooseAddMuestraOFinalizar).muestreo;
    yield LoadingMuestreo();
    yield OnChosingRangoEdad(muestreo: muestra);
  }

  Stream<MuestrasState> _chooseRangoEdad(ChooseRangoEdad event)async*{
    final Muestreo muestreo = (state as OnChosingRangoEdad).muestreo;
    yield LoadingMuestreo();
    yield OnTomaPesos(muestreo: muestreo, rangoId: event.rangoId);
  }

  Stream<MuestrasState> _addMuestraPesos(AddMuestraPesos event)async*{
    Muestreo muestreo = (state as OnTomaPesos).muestreo;
    final int rangoId = (state as OnTomaPesos).rangoId;
    yield LoadingMuestreo();
    final List<String> stringPesos = event.pesos;
    final eitherPesos = pesosConverter.convert(stringPesos);
    yield * eitherPesos.fold((_)async*{
      yield MuestraError(message: FORMAT_PESOS_ERROR);
    }, (pesos)async*{
      muestreo = muestreo.copyWith(nMuestras: muestreo.nMuestras+1);
      await setMuestra(SetMuestraParams(muestreoId: muestreo.id, selectedRangoId: rangoId, pesosTomados: pesos));
      final eitherMuestreo = await getMuestras(NoParams());
      yield * eitherMuestreo.fold((l)async*{
        yield MuestraError(message: GENERAL_ERROR_MESSAGE);
      }, (newMuestreo)async*{
        newMuestreo = newMuestreo.copyWith(rangos: muestreo.rangos);
        yield OnChooseAddMuestraOFinalizar(muestreo: newMuestreo);
      });
    });
  }

  Stream<MuestrasState> _initMuestraEdigint(InitMuestraEditing event)async *{
    final Muestreo muestreo = (state as LoadedMuestreo).muestreo;
    yield LoadingMuestreo();
    int rangoIndex = muestreo.stringRangos.indexWhere((r) => r == event.muestra.rango);
    yield OnEditingMuestra(
      muestra: event.muestra,
      indexMuestra: event.indexMuestra,
      pesosEsperados: muestreo.pesosEsperadosPorRango[rangoIndex],
      muestreo: muestreo
    );
  }

  Stream<MuestrasState> _chooseMuestra(ChooseMuestra event)async *{
    final Muestreo muestreo = (state as LoadedMuestreo).muestreo;
    yield LoadingMuestreo();
    yield OnMuestraDetail(muestra: event.muestra, muestreo: muestreo);
  }

  Stream<MuestrasState> _removeMuestra()async *{
    final Muestreo muestreo = (state as OnMuestraDetail).muestreo;
    final Muestra muestra = (state as OnMuestraDetail).muestra;
    yield LoadingMuestreo();
    final result = await removeMuestra(RemoveMuestraParams(muestraId: muestra.id));
    yield * result.fold((l)async*{
      yield MuestraError(message: GENERAL_ERROR_MESSAGE);
    }, (_)async*{
      yield MuestraRemoved(muestreo: muestreo);
    });
  }

  Stream<MuestrasState> _backFromMuestraDetail()async *{
    final List<Rango> rangos = (state as LoadedMuestreo).muestreo.rangos;
    yield LoadingMuestreo();
    final eitherMuestreo = await getMuestras(NoParams());
    yield * eitherMuestreo.fold((failure)async*{
      String message = (failure is ServerFailure)? failure.message : GENERAL_ERROR_MESSAGE;
      yield MuestraError(message: message);
    }, (muestreo)async*{
      muestreo = muestreo.copyWith(rangos: rangos);
      yield OnChooseAddMuestraOFinalizar(muestreo: muestreo);
    });
  }
}