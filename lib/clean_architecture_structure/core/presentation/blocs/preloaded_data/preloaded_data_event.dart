part of 'preloaded_data_bloc.dart';

abstract class PreloadedDataEvent extends Equatable {
  const PreloadedDataEvent();

  @override
  List<Object> get props => [];
}


class SendInitialPreloadedDataEvent extends PreloadedDataEvent{
  final NavigationRoute routeToGo;
  SendInitialPreloadedDataEvent({
    @required this.routeToGo
  });
}

class SendPreloadedDataEvent extends PreloadedDataEvent{}