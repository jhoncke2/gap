import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'adjuntar_imgs_a_visit_event.dart';
part 'adjuntar_imgs_a_visit_state.dart';

class AdjuntarImgsAVisitBloc extends Bloc<AdjuntarImgsAVisitEvent, AdjuntarImgsAVisitState> {
  AdjuntarImgsAVisitBloc() : super(AdjuntarImgsAVisitState());

  @override
  Stream<AdjuntarImgsAVisitState> mapEventToState(
    AdjuntarImgsAVisitEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
