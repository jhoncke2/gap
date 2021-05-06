import 'dart:async';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/preloaded/send_preloaded_data.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';

part 'preloaded_data_event.dart';
part 'preloaded_data_state.dart';

class PreloadedDataBloc extends Bloc<PreloadedDataEvent, PreloadedDataState> {
  final SendPreloadedData sendPreloadedData;
  final GoTo goTo;
  PreloadedDataBloc({
    @required this.sendPreloadedData,
    @required this.goTo
  }) : super(InactivePreloaded());

  @override
  Stream<PreloadedDataState> mapEventToState(
    PreloadedDataEvent event,
  ) async* {
    yield * _sendPreloadedData();
    if(event is SendInitialPreloadedDataEvent)
      goTo(NavigationParams(navRoute: event.routeToGo));
    yield InactivePreloaded();
  }

  Stream<PreloadedDataState> _sendPreloadedData()async*{
    yield SendingPreloaded();
    final eitherSend = await sendPreloadedData(NoParams());
    yield * eitherSend.fold((l)async*{
      yield FailedSentPreloaded();
    }, (r)async*{
      yield SuccessfulySentPreloaded();
    });
  }
}
