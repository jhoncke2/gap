import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/services/auth_service.dart';
import 'package:test/test.dart';

final Map<String, dynamic> failedLoginInfo = {
  'email':'email1@gmail.com',
  'password':'1234567'
};

final Map<String, dynamic> successLoginInfo = {
  'email':'Serviciotecnico@partesysuministros.com',
  'password':'Partes2018'
};

String successAccessToken;

void main(){
  group('se testeará succes/failed login y refresh_authtoken', (){
    _testFailedLogin();
    _testSuccessLogin();
    _testRefreshAccessToken();
  });
  
}

void _testFailedLogin(){
  test('Se testeará método de login fallido', ()async{
    try{
      await _tryTestFailedLogin();
    }on ServiceStatusErr catch(_){
      print(_);
      return;
    }catch(err){
      fail('No debería ocurrir algún error que no sea ServiceStatus: $err');
    }
  });
}

Future _tryTestFailedLogin()async{
  final Map<String, dynamic> loginResponse = await authService.login(failedLoginInfo);
  fail('El response $loginResponse no se deberia haber retornado. Deberia haber sido un ServiceStatusErr.');
}

void _testSuccessLogin(){
  test('Se testeará método de login exitoso', ()async{
    try{
      await _tryTestSuccessLogin();
    }on ServiceStatusErr catch(se){
      fail('No debería ocurrir un ServiceStatusErr: ${se.status}::${se.message}');
    }catch(err){
      fail('No debería ocurrir algún error que no sea ServiceStatus: $err');
    }
  });
}

Future _tryTestSuccessLogin()async{
  final Map<String, dynamic> loginResponse = await authService.login(successLoginInfo);
  final Map<String, dynamic> originalData = loginResponse['data']['original'];
  expect(originalData, isNotNull, reason: 'el original data no debe ser null');
  expect(originalData['access_token'], isNotNull, reason: 'El token no debe ser null');
  successAccessToken = originalData['access_token'];
}

Future _testRefreshAccessToken()async{
  test('Se testeará método de refresh auth tokeen', ()async{
    try{
      await _tryRefreshAccessToken();
    }on ServiceStatusErr catch(se){
      fail('No debería ocurrir un ServiceStatusErr: ${se.status}::${se.message}');
    }catch(err){
      fail('No debería ocurrir algún error que no sea ServiceStatus: $err');
    }
  });
}

Future _tryRefreshAccessToken()async{
  final Map<String, dynamic> response = await authService.refreshAuthToken(successAccessToken);
  final originalData = response['data']['original'];
  expect(originalData, isNotNull);
  expect(originalData['access_token'], isNotNull);
}