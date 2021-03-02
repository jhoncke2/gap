part of 'chosen_form_bloc.dart';

@immutable
abstract class ChosenFormEvent{}

class InitFormFillingOut extends ChosenFormEvent{
  final Formulario formulario;
  final void Function(int) onEndEvent;
  InitFormFillingOut({
    @required this.formulario,
    @required this.onEndEvent
  });
}

class InitFirstFirmerFillingOut extends ChosenFormEvent{}

class InitFirstFirmerFirm extends ChosenFormEvent{}

class InitFirmsFillingOut extends ChosenFormEvent{}

class UpdateFirmerPersonalInformation extends ChosenFormEvent{
  final PersonalInformation firmer;
  UpdateFirmerPersonalInformation({
    @required this.firmer
  });
}

class ResetChosenForm extends ChosenFormEvent{}
