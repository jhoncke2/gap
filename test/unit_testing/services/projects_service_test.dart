import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/services/auth_service.dart';
import 'package:gap/services/projects_service.dart';

final Map<String, dynamic> loginInfo = {
  'email':'oskrjag@gmail.com',
  'password':'12345678'
};

List<Map<String, dynamic>> projectsResponse;

void main(){
  group('login para el auth token y get projects', (){
    _testGetProjects();
  });
}

void _testGetProjects(){
  test('Se testeará méodo de login fallido', ()async{
    try{
      await _tryGetProjects();
    }on ServiceStatusErr catch(_){
      print(_);
      return;
    }catch(err){
      fail('No debería ocurrir algún error que no sea ServiceStatus');
    }
  });
}

Future _tryGetProjects()async{
  final String accessToken = await _login();
  projectsResponse = await projectsService.getProjects(accessToken);
  expect(projectsResponse, isNotNull);

  expect(projectsResponse.length, isNot(0));
  final List<Project> projects = projectsFromJson(projectsResponse);
  expect(projects, isNotNull);
  expect(projects.length, isNot(0));
}

Future<String> _login()async{
  final Map<String, dynamic> loginResponse = await authService.login(loginInfo);
  return loginResponse['data']['original']['access_token'];
}

