import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/services/auth_service.dart';
import 'package:gap/services/projects_service.dart';
import 'package:geolocator/geolocator.dart';

final Map<String, dynamic> loginInfo = {
  'email':'oskrjag@gmail.com',
  'password':'12345678'
};

final DateTime nowTime = DateTime.now();

final PersonalInformation firmer = PersonalInformation.fromJson({
  'name':'Parangaricutirimicuaro ${nowTime.year}_${nowTime.month}_${nowTime.day}_${nowTime.hour}_${nowTime.minute}_${nowTime.second}_${nowTime.millisecond}',
  'identif_document_type':'CC',
  'identif_document_number':123456789,
  'firm':'assets/logos/logo_con_fondo.png'
});

final List<CommentedImage> commentedImages = [
  CommentedImage.fromJson({
    'image_path':'assets/logos/logo_con_fondo.png',
    'commentary':'Commentary 1'
  }),
  CommentedImage.fromJson({
    'image_path':'assets/logos/logo_sin_fondo.png',
    'commentary':'Commentary 2'
  }),
  CommentedImage.fromJson({
    'image_path':'assets/logos/logo_con_fondo.png',
    'commentary':'Commentary 2'
  }),
];

List<Map<String, dynamic>> projectsResponse;
String accessToken;

void main(){
  _testGroup();
}

void _testGroup(){
  group('login para el auth token, get projects, y updateForm', (){
    //Tests se comentan para no interferir con el accessToken de la app.
    _testGetProjects();
    _testUpdateForm();
    _testPostFirmer();
    _testPostCommentedImages();
    _testPostFormInitialData();
    _testPostFormFinalData();
  });
}

Future _testGetProjects()async{
  test('Se testeará méodo de get projects', ()async{
    try{
      await _tryGetProjects();
    }on ServiceStatusErr catch(err){
      fail('${err.message}::${err.extraInformation??"no extra information"}');
    }catch(err){
      throw err;
    }
  });
}

Future _tryGetProjects()async{

  final String nowTime = DateTime.now().toIso8601String();
  print(nowTime);

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
    try{
      await _tryUpdateForm();
    }on ServiceStatusErr catch(err){
      fail('${err.message}::${err.extraInformation??"no extra information"}');
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future _tryUpdateForm()async{
  final Map<String, dynamic> formWithFormFieldsAndItsVisitId = _getFormWithFormFieldsAndItsVisitId();
  final List<Map<String, dynamic>> formCampos = _getFormattedFormCampos(formWithFormFieldsAndItsVisitId['form']);
  final List<Map<String, dynamic>> updatedFormResponse = await projectsService.updateForm(accessToken, formCampos, formWithFormFieldsAndItsVisitId['visit_id']);
  expect(updatedFormResponse, isNotNull);
  expect(updatedFormResponse.length, formCampos.length);
}

Map<String, dynamic> _getFormWithFormFieldsAndItsVisitId(){
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
    'formulario_visita_id':formId,
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

Future _testPostFirmer()async{
  test('Se testeará el método postFirmer', ()async{
    try{
      await _tryPostFirmer();
    }on ServiceStatusErr catch(err){
      fail('${err.message}::${err.extraInformation??"no extra information"}');
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future _tryPostFirmer()async{
  final String authToken = await _login();
  final Map<String, dynamic> formWithFormFields = _getFormWithFormFieldsAndItsVisitId();
  final Map<String, dynamic> serviceResponse = await projectsService.saveFirmer(authToken, firmer, formWithFormFields['form'].id, formWithFormFields['visit_id']);
  expect(serviceResponse, isNotNull);
  expect(serviceResponse['formulario_visita_id'], formWithFormFields['form'].id.toString());
  expect(serviceResponse['visita_id'], formWithFormFields['visit_id']);
  expect(serviceResponse['ruta'], isNotNull);
  final Map<String, String> jsonFirmerResponse = {
    'tipo_dc':serviceResponse['tipo_dc'],
    'cc':serviceResponse['cc'],
    'nombre':serviceResponse['nombre']
  };
  expect(jsonFirmerResponse, firmer.toServiceJson());
}

Future _testPostCommentedImages()async{
  test('Se testeará el método postCommentedImages', ()async{
    await _tryPostCommentedImages();
  });
}

Future _tryPostCommentedImages()async{
  final String accessToken = await _login();
  final Map<String, dynamic> formWithFormFieldsAndItsVisitId = _getFormWithFormFieldsAndItsVisitId();
  final List<File> imgFiles = [];
  final List<String> imgCommentaries = [];
  _separateImgsToComments(imgFiles, imgCommentaries);
  final List<Map<String, dynamic>> serviceResponse = await projectsService.saveCommentedImages(accessToken, imgFiles, imgCommentaries, formWithFormFieldsAndItsVisitId['visit_id']);
  expect(serviceResponse, isNotNull);
  expect(serviceResponse.length, commentedImages.length);
  for(int i = 0; i < serviceResponse.length; i++)
    _expectServiceReturnedCommImg(serviceResponse, i, formWithFormFieldsAndItsVisitId['visit_id']);
}

void _separateImgsToComments(List<File> files, List<String> comments){
  commentedImages.forEach((commImg) {
    files.add(commImg.image);
    comments.add(commImg.commentary);
  });
}

void _expectServiceReturnedCommImg(List<Map<String, dynamic>> serviceResponse, int index, int visitId){
  final Map<String, dynamic> jsonCommImg = serviceResponse[index];
    expect(jsonCommImg['visita_id'], visitId);
    expect(jsonCommImg['descripcion'], commentedImages[index].commentary);
    expect(jsonCommImg['ruta'], isNotNull);
}

void _testPostFormInitialData(){
  test('se testeará el método postFormInitialData', ()async{
    try{
      await _tryTestPostFormInitialData();
    }on ServiceStatusErr catch(err){
      fail('Ocurrió un service error: ${err.message}:${err.extraInformation??"No extra information"}');
    }catch(err){
      fail(err);      
    }
  });
}

Future _tryTestPostFormInitialData()async{
  final Map<String, dynamic> formData = _getFormWithFormFieldsAndItsVisitId();
  final Formulario form = formData['form'];
  form.initialPosition = Position(latitude: 5.25, longitude: 13.2);
  final Map<String, dynamic> body = {
    "latitud_inicio":form.initialPosition.latitude.toString(),
    "longitud_inicio":form.initialPosition.longitude.toString()
  };
  final Map<String, dynamic> serviceResponse = await projectsService.postFormInitialData(accessToken, body, form.id);
  expect(serviceResponse, isNotNull);
  expect(serviceResponse['id'], form.id);
  expect(serviceResponse['visita_id'], formData['visit_id']);
  expect(serviceResponse['latitud_inicio'], form.initialPosition.latitude.toString());
  expect(serviceResponse['longitud_inicio'], form.initialPosition.longitude.toString());
  print(serviceResponse);
}

void _testPostFormFinalData(){
  test('se testeará el método postFormFinalData', ()async{
    try{
      await _tryTestPostFormFinalData();
    }on ServiceStatusErr catch(err){
      fail('Ocurrió un service error: ${err.message}:${err.extraInformation??"No extra information"}');
    }catch(err){
      fail(err);      
    }
  });
}

Future _tryTestPostFormFinalData()async{
  final Map<String, dynamic> formData = _getFormWithFormFieldsAndItsVisitId();
  final Formulario form = formData['form'];
  form.initialPosition = Position(latitude: 5.25, longitude: 13.2);
  final Map<String, dynamic> body = {
    "latitud_final":form.initialPosition.latitude.toString(),
    "longitud_final":form.initialPosition.longitude.toString()
  };
  final Map<String, dynamic> serviceResponse = await projectsService.postFormFinalData(accessToken, body, form.id);
  expect(serviceResponse, isNotNull);
  expect(serviceResponse['id'], form.id);
  expect(serviceResponse['visita_id'], formData['visit_id']);
  expect(serviceResponse['latitud_final'], form.initialPosition.latitude.toString());
  expect(serviceResponse['longitud_final'], form.initialPosition.longitude.toString());
  print(serviceResponse);
}