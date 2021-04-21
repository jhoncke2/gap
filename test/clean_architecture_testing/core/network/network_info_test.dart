import 'package:connectivity/connectivity.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockConnectivity extends Mock implements Connectivity{
  
}

NetworkInfoImpl networkInfo;
MockConnectivity connectivity;

void main(){
  setUp((){
    connectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(connectivity: connectivity);
  });

  group('isConnected', (){

    test('should return true when connectivity is wifi.', ()async{
      when(connectivity.checkConnectivity()).thenAnswer((realInvocation) async => ConnectivityResult.wifi);
      final isConnected = await networkInfo.isConnected();
      verify(connectivity.checkConnectivity());
      expect(isConnected, true);
    });

    test('should return true when connectivity is mobile.', ()async{
      when(connectivity.checkConnectivity()).thenAnswer((realInvocation) async => ConnectivityResult.mobile);
      final isConnected = await networkInfo.isConnected();
      verify(connectivity.checkConnectivity());
      expect(isConnected, true);
    });

    test('should return false when connectivity is none.', ()async{
      when(connectivity.checkConnectivity()).thenAnswer((realInvocation) async => ConnectivityResult.none);
      final isConnected = await networkInfo.isConnected();
      verify(connectivity.checkConnectivity());
      expect(isConnected, false);
    });
  });
}