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

class InitFirmsFillingOut extends ChosenFormEvent{}

class AddFirmerPersonalInformation extends ChosenFormEvent{
  final PersonalInformation firmer;
  AddFirmerPersonalInformation({
    @required this.firmer
  });
}

class ResetChosenForm extends ChosenFormEvent{}
