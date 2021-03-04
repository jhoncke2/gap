import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/services/auth_service.dart';
import 'package:gap/services/projects_service.dart';

final Map<String, dynamic> loginInfo = {
  'email':'oskrjag@gmail.com',
  'password':'12345678'
};

List<Map<String, dynamic>> projectsResponse;
String accessToken;

void main(){
  group('login para el auth token, get projects, y updateForm', (){
    _testGetProjects();
    _testUpdateForm();
  });
}

Future _testGetProjects()async{
  test('Se testeará méodo de login fallido', ()async{
    try{
      await _tryGetProjects();
    }on ServiceStatusErr catch(_){
      print(_);
      return;
    }catch(err){
      throw err;
    }
  });
}

Future _tryGetProjects()async{
  accessToken = await _login();
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

Future _testUpdateForm()async{
  test('Se testeará el método updateForm', ()async{
    await _tryUpdateForm();
  });
}

Future _tryUpdateForm()async{
  final Map<String, dynamic> formWithFormFields = _getFormWithFormFields();
  final List<Map<String, dynamic>> formCampos = _getFormattedFormCampos(formWithFormFields['form']);
  final Map<String, dynamic> updatedFormResponse = await projectsService.updateForm(accessToken, formCampos, formWithFormFields['visit_id']);
  expect(updatedFormResponse, isNotNull);
  expect(updatedFormResponse['data'], isNotNull);
  expect(updatedFormResponse['data']['id'], isNotNull);
}

Map<String, dynamic> _getFormWithFormFields(){
  final List<Project> projects = projectsFromJson(projectsResponse);
  for(Project p in projects)
    for(Visit v in p.visits)
      for(Formulario f in v.formularios)
        if(f.campos.length > 0)
          return {'visit_id':v.id, 'form':f};
  fail('No existe formulario que tenga lista no vacia de campos');
}

List<Map<String, dynamic>> _getFormattedFormCampos(Formulario form){
  final List<Map<String, dynamic>> jsonCampos = [];
  for(CustomFormField cff in form.campos)
    if(cff is VariableFormField)
      _addVariableFormFieldToList(cff, jsonCampos, form.id); 
  return jsonCampos;
}

void _addVariableFormFieldToList(VariableFormField vff, List<Map<String, dynamic>> jsonCampos, int formId){
  final Map<String, dynamic> jsonCff = _getServiceJsonByVariableFormField(vff, formId);
  _defineFormFieldValuesByTypeOfValues(vff, jsonCff);
  jsonCampos.add(jsonCff);
}

Map<String, dynamic> _getServiceJsonByVariableFormField(VariableFormField vff, int formId){
  return {
    'formulario_g_formulario_id':formId,
    'name':vff.name
  };
}

void _defineFormFieldValuesByTypeOfValues(VariableFormField vff, Map<String, dynamic> jsonVff){
  if(vff is SingleValueFormField){
    jsonVff['res'] = [vff.uniqueValue];
  }else if(vff is MultiValueFormField){
    jsonVff['res'] = (vff.values.where((element) => element.selected)).map<String>((e) => e.value).toList();
  }
}

