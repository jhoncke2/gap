import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forms_widgets_event.dart';
part 'forms_widgets_state.dart';

class FormsWidgetsBloc extends Bloc<FormsWidgetsEvent, FormsWidgetsState> {
  FormsWidgetsBloc() : super(FormsWidgetsInitial());

  @override
  Stream<FormsWidgetsState> mapEventToState(
    FormsWidgetsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
