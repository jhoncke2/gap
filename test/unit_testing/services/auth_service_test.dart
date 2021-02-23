import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/services/auth_service.dart';
import 'package:test/test.dart';

final Map<String, dynamic> failedLoginInfo = {
    'email':'email1@gmail.com',
    'password':'1234'
  };

void main(){
  _testFailedLogin();
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