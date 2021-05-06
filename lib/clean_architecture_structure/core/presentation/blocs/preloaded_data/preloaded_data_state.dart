part of 'preloaded_data_bloc.dart';

abstract class PreloadedDataState extends Equatable {
  const PreloadedDataState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class InactivePreloaded extends PreloadedDataState {
}

class SendingPreloaded extends PreloadedDataState {
}

class SuccessfulySentPreloaded extends PreloadedDataState {
}

class FailedSentPreloaded extends PreloadedDataState {
}