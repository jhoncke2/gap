part of 'chosen_form_bloc.dart';

@immutable
abstract class ChosenFormEvent{}

class InitFormFillingOut extends ChosenFormEvent{
  final Formulario formulario;
  InitFormFillingOut({
    @required this.formulario
  });
}

class InitFirstFirmerFillingOut extends ChosenFormEvent{}

class InitFirstFirmerFirm extends ChosenFormEvent{}

class InitFirmsFillingOut extends ChosenFormEvent{}

class UpdateFirmerPersonalInformation extends ChosenFormEvent{
  final int firmerListIndex;
  final PersonalInformation firmer;
  UpdateFirmerPersonalInformation({
    @required this.firmer,
    @required this.firmerListIndex
  });
}

class ResetChosenForm extends ChosenFormEvent{}
