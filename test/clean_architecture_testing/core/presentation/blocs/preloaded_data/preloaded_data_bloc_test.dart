import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/preloaded/send_preloaded_data.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/preloaded_data/preloaded_data_bloc.dart';

class MockSendPreloadedData extends Mock implements SendPreloadedData{}
class MockGoTo extends Mock implements GoTo{}

PreloadedDataBloc bloc;
MockSendPreloadedData sendPrelDataUseCase;
MockGoTo navigationUseCase;

void main(){
  setUp((){
    navigationUseCase = MockGoTo();
    sendPrelDataUseCase = MockSendPreloadedData();
    bloc = PreloadedDataBloc(
      sendPreloadedData: sendPrelDataUseCase,
      goTo: navigationUseCase
    );
  });

  test('the initial state should be InactivePreloaded', ()async{
    expect(bloc.state, InactivePreloaded());
  });

  group('sendInitialPreloadedData', (){
    NavigationRoute tRouteToGo;
    setUp((){
      tRouteToGo = NavigationRoute.Formularios;
    });
    test('should call the sendPreloadedData useCase and the goTo useCase', ()async{
      when(sendPrelDataUseCase.call(any)).thenAnswer((_) async => Right(true));
      bloc.add(SendInitialPreloadedDataEvent(routeToGo: tRouteToGo));
      await untilCalled(sendPrelDataUseCase.call(any));
      verify(sendPrelDataUseCase.call(NoParams()));
      await untilCalled(navigationUseCase.call(any));
      verify(navigationUseCase.call(NavigationParams(navRoute: tRouteToGo)));
    });

    test('should yield the specified states when all goes good', ()async{
      when(sendPrelDataUseCase.call(any)).thenAnswer((_) async => Right(true));
      final expectedOrderedStates = [
        SendingPreloaded(),
        SuccessfulySentPreloaded(),
        InactivePreloaded()
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SendInitialPreloadedDataEvent(routeToGo: tRouteToGo));
    });

    test('should yield the specified states when useCase fail', ()async{
      when(sendPrelDataUseCase.call(any)).thenAnswer((_) async => Left(ServerFailure(message: '')));
      final expectedOrderedStates = [
        SendingPreloaded(),
        FailedSentPreloaded(),
        InactivePreloaded()
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SendInitialPreloadedDataEvent(routeToGo: tRouteToGo));
    });
  });

  group('sendPreloadedData', (){
    test('should call the sendPreloadedData useCase', ()async{
      when(sendPrelDataUseCase.call(any)).thenAnswer((_) async => Right(true));
      bloc.add(SendPreloadedDataEvent());
      await untilCalled(sendPrelDataUseCase.call(any));
      verify(sendPrelDataUseCase.call(NoParams()));
      verifyNever(navigationUseCase.call(any));
    });

    test('should yield the specified states when all goes good', ()async{
      when(sendPrelDataUseCase.call(any)).thenAnswer((_) async => Right(true));
      final expectedOrderedStates = [
        SendingPreloaded(),
        SuccessfulySentPreloaded(),
        InactivePreloaded()
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SendPreloadedDataEvent());
    });

    test('should yield the specified states when useCase fail', ()async{
      when(sendPrelDataUseCase.call(any)).thenAnswer((_) async => Left(ServerFailure(message: '')));
      final expectedOrderedStates = [
        SendingPreloaded(),
        FailedSentPreloaded(),
        InactivePreloaded()
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SendPreloadedDataEvent());
    });
  });
}
