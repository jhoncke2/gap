import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/logic/models/entities/form_field.dart';
import 'package:gap/logic/models/entities/formulario.dart';
import 'package:gap/logic/models/entities/personal_information.dart';
import 'package:meta/meta.dart';

part 'chosen_form_event.dart';
part 'chosen_form_state.dart';

class ChosenFormBloc extends Bloc<ChosenFormEvent, ChosenFormState> {
  ChosenFormBloc() : super(ChosenFormState());

  @override
  Stream<ChosenFormState> mapEventToState(
    ChosenFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
