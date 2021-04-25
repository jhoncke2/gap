import 'package:gap/clean_architecture_structure/core/domain/entities/entity_with_stage.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'custom_position.dart';
import 'firmer.dart';

final List<FormStep> stepsInOrder = [
  FormStep.WithoutForm,
  FormStep.OnFormFillingOut,
  FormStep.OnFormReading,
  FormStep.OnFirstFirmerInformation,
  FormStep.OnFirstFirmerFirm,
  FormStep.OnSecondaryFirms,
  FormStep.Finished
];

final formStepValues = EnumValuesOld({
  'on_form_filling_out':FormStep.OnFormFillingOut,
  'on_form_reading':FormStep.OnFormReading,
  'on_first_firmer_information':FormStep.OnFirstFirmerInformation,
  'on_secondary_firms':FormStep.OnSecondaryFirms,
  'finished':FormStep.Finished
});

// ignore: must_be_immutable
class Formulario extends EntityWithStage{
  final int id;
  bool completo;
  final DateTime initialDate;
  final List<Firmer> firmers;
  final List<CustomFormFieldOld> campos;
  int formStepIndex;
  final CustomPosition initialPosition;
  final CustomPosition finalPosition;

  Formulario({
    this.id,
    this.completo,
    this.initialDate, 
    this.firmers,
    this.campos, 
    this.formStepIndex, 
    this.initialPosition,
    this.finalPosition,
    String nombre
  }):super(
    name: nombre,
    stage: (completo)? ProcessStage.Realizada : ProcessStage.Pendiente
  );

  @override
  List<Object> get props => [];

  set formStep(FormStep formStep){
    formStepIndex = stepsInOrder.indexWhere((element) => element == formStep);
    _defineCompletoAndStage();
  }

  get formStep => stepsInOrder[formStepIndex];

  void advanceInStep(){
    formStepIndex = (++formStepIndex % stepsInOrder.length);
    _defineCompletoAndStage();
  }

  void _defineCompletoAndStage(){
    if(stepsInOrder[formStepIndex] == FormStep.Finished){
      completo = true;
      stage = ProcessStage.Realizada;
    }
  }
}

