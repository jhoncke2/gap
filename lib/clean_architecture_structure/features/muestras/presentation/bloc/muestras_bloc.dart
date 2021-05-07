import 'dart:async';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';

part 'muestras_event.dart';
part 'muestras_state.dart';

class MuestrasBloc extends Bloc<MuestrasEvent, MuestrasState>{
  static const GENERAL_ERROR_MESSAGE = 'Ocurrió un error inesperado';

  final GetMuestras getMuestras;
  final SetMuestra setMuestra;

  MuestrasBloc({
    @required this.getMuestras,
    @required this.setMuestra   
  }) : super(MuestrasEmpty());

  @override
  Stream<MuestrasState> mapEventToState(
    MuestrasEvent event,
  ) async* {
    if(event is GetMuestraEvent){
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
    }else if(event is SetMuestraPreparaciones){
      final List<String> preparaciones = event.preparaciones;
      final Muestra muestra =  (state as OnPreparacionMuestra).muestra;
      yield LoadingMuestra();
      final List<Componente> componentes = muestra.componentes;
      for(int i = 0; i < componentes.length; i++){
        componentes[i].preparacion = preparaciones[i];
      }
      yield OnEleccionTomaOFinalizar(muestra: muestra);
    }
    
    
  }
}
