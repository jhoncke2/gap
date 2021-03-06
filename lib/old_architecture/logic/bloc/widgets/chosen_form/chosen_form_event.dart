part of 'chosen_form_bloc.dart';

@immutable
abstract class ChosenFormEvent{}

class ChangeFormIsLocked extends ChosenFormEvent{
  final bool isLocked;
  ChangeFormIsLocked({@required this.isLocked});
}

class InitFormFillingOut extends ChosenFormEvent{
  final FormularioOld formulario;
  final void Function(int) onEndEvent;
  InitFormFillingOut({
    @required this.formulario,
    @required this.onEndEvent
  });
}

class InitFormReading extends ChosenFormEvent{
  final FormularioOld formulario;
  final void Function(int) onEndEvent;

  InitFormReading({
    @required this.formulario, 
    this.onEndEvent
  });
}

class InitFirstFirmerFillingOut extends ChosenFormEvent{}

class InitFirstFirmerFirm extends ChosenFormEvent{}

class InitFirmsFillingOut extends ChosenFormEvent{}

class InitFirmsFinishing extends ChosenFormEvent{}

class InitFormFinishing extends ChosenFormEvent{
  final Function onEnd;
  final FormularioOld form;
  InitFormFinishing({
    @required this.onEnd,
    @required this.form
  });
}

class UpdateFirmerPersonalInformation extends ChosenFormEvent{
  final PersonalInformationOld firmer;
  UpdateFirmerPersonalInformation({
    @required this.firmer
  });
}

class UpdateFormField extends ChosenFormEvent{
  final Future Function(bool) onEndFunction;
  final int pageOfFormField;
  UpdateFormField({@required this.onEndFunction, @required this.pageOfFormField});
}

class ResetChosenForm extends ChosenFormEvent{}
