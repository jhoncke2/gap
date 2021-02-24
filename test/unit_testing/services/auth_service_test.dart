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

void main(){
  _testFailedLogin();
  _testSuccessLogin();
}

void _testFailedLogin(){
  test('Se testeará método de login fallido', ()async{
    try{
      await _tryTestFailedLogin();
    }on ServiceStatusErr catch(_){
      print(_);
      return;
    }catch(err){
      fail('No debería ocurrir algún error que no sea ServiceStatus');
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
      fail('No debería ocurrir algún error que no sea ServiceStatus');
    }
  });
}

Future _tryTestSuccessLogin()async{
  final Map<String, dynamic> loginResponse = await authService.login(successLoginInfo);
  final Map<String, dynamic> originalData = loginResponse['data']['original'];
  expect(originalData, isNotNull, reason: 'el original data no debe ser null');
  expect(originalData['access_token'], isNotNull, reason: 'El token no debe ser null');
}