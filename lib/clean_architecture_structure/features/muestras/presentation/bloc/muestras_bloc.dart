import 'dart:async';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/save_formulario.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_formulario.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/remove_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/update_preparaciones.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/utils/string_to_double_converter.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';

part 'muestras_event.dart';
part 'muestras_state.dart';

class MuestrasBloc extends Bloc<MuestrasEvent, MuestrasState>{
  static const GENERAL_ERROR_MESSAGE = 'Ha ocurrido un error';
  static const FORMAT_PESOS_ERROR = 'Hay un problema con el formato de los pesos';
  static const PRE_FORMULARIO_TYPE = 'Pre';
  static const POS_FORMULARIO_TYPE = 'Pos';

  final GetMuestras getMuestras;
  final SetMuestra setMuestra;
  final UpdatePreparaciones updatePreparaciones;
  final RemoveMuestra removeMuestra;
  final GetFormulario getFormulario;
  final SaveFormulario saveFormulario;
  final StringToDoubleConverter pesosConverter;

  MuestrasBloc({
    @required this.getMuestras,
    @required this.setMuestra,
    @required this.updatePreparaciones,
    @required this.removeMuestra,
    @required this.getFormulario,
    @required this.saveFormulario,
    @required this.pesosConverter
  }) : super(OnMuestreoEmpty()){
    //add(GetMuestraEvent());
  }

  @override
  Stream<MuestrasState> mapEventToState(
    MuestrasEvent event,
  ) async* {
    if(event is InitMuestreoEvent){
      yield * _initMuestreo();
    }else if(event is EndInitialFormulario){
      yield * _endInitialFormulario(event);
    }else if(event is InitTomaMuestras){
      yield * _initTomaMuestras();
    }else if(event is EndTomaMuestras){
      yield * _endTomaMuestras();
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
    }else if(event is EndFinalFormulario){
      yield * _endFinalFormulario(event);
    }
  }

  Stream<MuestrasState> _initMuestreo()async*{
    yield LoadingMuestreo();
    final eitherMuestreo = await getMuestras(NoParams());
    yield * eitherMuestreo.fold((failure)async*{
      String message = (failure is ServerFailure)? failure.message : GENERAL_ERROR_MESSAGE;
      yield MuestraError(message: message);
    }, (muestreo)async*{
      if(muestreo.preFormulario != null){
        yield * _loadFormularioInicial(muestreo);
      }else if(muestreo.componentes != null && muestreo.componentes.length > 0){
        yield * _initMuestrasProcess(muestreo);
      }else if(muestreo.posFormulario != null){
        yield * _loadFormularioFinal(muestreo);
      }else{
        yield MuestreoFinished(muestreo: muestreo);
      }
    });
  }

  Stream<MuestrasState> _loadFormularioInicial(Muestreo muestreo)async*{
    yield LoadingFormulario();
    yield LoadedInitialFormulario(formulario: muestreo.preFormulario, muestreo: muestreo);
  }
  
  Stream<MuestrasState> _endInitialFormulario(EndInitialFormulario event)async*{
    final Muestreo muestreo = (state as LoadedMuestreo).muestreo;
    yield LoadingFormulario();
    await saveFormulario(SaveFormularioParams( muestreoId: muestreo.id, formulario: event.formulario, formularioType: PRE_FORMULARIO_TYPE));
    if(muestreo.componentes != null && muestreo.componentes.length > 0){
      yield * _initMuestrasProcess(muestreo);
    }else if (muestreo.posFormulario != null)
      yield * _loadFormularioFinal(muestreo);
    else
      yield MuestreoFinished(muestreo: muestreo);
  }

  Stream<MuestrasState> _endTomaMuestras()async*{
    final Muestreo muestreo = (state as LoadedMuestreo).muestreo;
    if (muestreo.posFormulario != null)
      yield * _loadFormularioFinal(muestreo);
    else
      yield MuestreoFinished(muestreo: muestreo);
  }

  Stream<MuestrasState> _initMuestrasProcess(Muestreo muestreo)async*{
    if(muestreo.muestrasTomadas.isEmpty)
      yield OnPreparacionMuestreo(muestreo: muestreo);
    else
      yield OnChooseAddMuestraOFinalizar(muestreo: muestreo);
  }

  Stream<MuestrasState> _loadFormularioFinal(Muestreo muestreo)async*{
    yield LoadingFormulario();
    yield LoadedFinalFormulario(formulario: muestreo.posFormulario, muestreo: muestreo);
  }

  Stream<MuestrasState> _initTomaMuestras()async*{
    final Muestreo muestreo = (state as LoadedMuestreo).muestreo;
    yield OnPreparacionMuestreo(muestreo: muestreo);
  }

  Stream<MuestrasState> _setMuestreoPreparaciones(SetMuestreoPreparaciones event)async*{
    final Muestreo muestreo =  (state as OnPreparacionMuestreo).muestreo;
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
      pesosEsperados: muestreo.rangos[rangoIndex].pesosEsperados,
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

  Stream<MuestrasState> _endFinalFormulario(EndFinalFormulario event)async*{
    final Muestreo muestreo = (state as LoadedMuestreo).muestreo;
    yield LoadingFormulario();
    await saveFormulario(SaveFormularioParams(muestreoId: muestreo.id, formulario: event.formulario, formularioType: POS_FORMULARIO_TYPE));
    yield MuestreoFinished(muestreo: muestreo);
  }
}