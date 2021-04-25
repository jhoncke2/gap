import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/errors/services/service_status_err.dart';
import 'package:gap/old_architecture/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/old_architecture/services/projects_service.dart';

class ProjectsServicesManager{

  Future<List<ProjectOld>> loadProjects(ProjectsBloc bloc, String accessToken)async{
    final dynamic projectsResponse = await projectsService.getProjects(accessToken);
    final List<ProjectOld> projects = projectsFromJson(projectsResponse);
    return projects;
  }

  static Future updateForm(FormularioOld form, int visitId, String accessToken)async{
    final List<Map<String, dynamic>> formattedFormCampos = _getFormattedFormCampos(form);
    final List<Map<String, dynamic>> response = await projectsService.updateForm(accessToken, formattedFormCampos, visitId);
    _throwErrIsUpdateFormIsntOk(response, formattedFormCampos);
  }

  static List<Map<String, dynamic>> _getFormattedFormCampos(FormularioOld form){
    final List<Map<String, dynamic>> jsonCampos = [];
    for(CustomFormFieldOld cff in form.campos)
      if(cff is VariableFormFieldOld)
        _addVariableFormFieldToList(cff, jsonCampos, form.id); 
    return jsonCampos;
  }

  static void _addVariableFormFieldToList(VariableFormFieldOld vff, List<Map<String, dynamic>> jsonCampos, int formId){
    final Map<String, dynamic> jsonCff = _getServiceJsonByVariableFormField(vff, formId);
    _defineFormFieldValuesByTypeOfValues(vff, jsonCff);
    jsonCampos.add(jsonCff);
  }

  static Map<String, dynamic> _getServiceJsonByVariableFormField(VariableFormFieldOld vff, int formId){
    return {
      'formulario_visita_id': formId,
      'name': vff.name
    };
  }

  static void _defineFormFieldValuesByTypeOfValues(VariableFormFieldOld vff, Map<String, dynamic> jsonVff){
    if(vff is SingleValueFormFieldOld){
      jsonVff['res'] = [vff.uniqueValue??''];
    }else if(vff is MultiValueFormFieldOld){
      jsonVff['res'] = (vff.values.map<int>((item) => item.selected?1:0)).toList();
    }
  }

  static void _throwErrIsUpdateFormIsntOk(List<Map<String, dynamic>> response, List<Map<String, dynamic>> formattedFormCampos){
    if(!_updateFormResponseIsOk(response, formattedFormCampos))
      throw ServiceStatusErr(message: 'El servicio de enviar el formulario no se efectuó correctamente');
  }

  static bool _updateFormResponseIsOk(List<Map<String, dynamic>> response, List<Map<String, dynamic>> formattedFormCampos){
    return response.length == formattedFormCampos.length;
  }

  static Future saveFirmer(String accessToken, PersonalInformationOld firmer, int formId, int visitId)async{
    final Map<String, dynamic> serviceResponse = await projectsService.saveFirmer(accessToken, firmer, formId, visitId);
    _throwErrIfFirmerFailed(serviceResponse);
  }

  static void _throwErrIfFirmerFailed(Map<String, dynamic> serviceResponse){
    if(!_saveFirmerResponseIsOk(serviceResponse))
      throw ServiceStatusErr(message: 'save firmer failed');
  }

  static bool _saveFirmerResponseIsOk(Map<String, dynamic> response){
    return ![response['ruta'], response['tipo_dc'], response['cc'], response['nombre']].contains(null);
  }

  static Future saveCommentedImages(String accessToken, List<UnSentCommentedImageOld> commentedImages, int visitId)async{
    final List<File> imgFiles = [];
    final List<String> imgCommentaries = [];
    _separateImgsAndComments(commentedImages, imgFiles, imgCommentaries);
    final List<Map<String, dynamic>> serviceResponse = await projectsService.saveCommentedImages(accessToken, imgFiles, imgCommentaries, visitId);
    _throwErrIfSaveCommImgsFailed(serviceResponse, commentedImages, visitId);
  }

  static void _separateImgsAndComments(List<UnSentCommentedImageOld> commentedImages, List<File> files, List<String> comments){
    commentedImages.forEach((commImg) {
      files.add(commImg.image);
      comments.add(commImg.commentary);
    });
  }

  static void _throwErrIfSaveCommImgsFailed(List<Map<String, dynamic>> serviceResponse, List<UnSentCommentedImageOld> commImgs, visitId){
    if(serviceResponse.length!=commImgs.length)
      throw ServiceStatusErr(message: 'Servicio de guardar imágemnes comentadas incompleto.');
    _evaluateIfAllReturnedCommImgsAreOk(serviceResponse, commImgs, visitId);
  }

  static void _evaluateIfAllReturnedCommImgsAreOk(List<Map<String, dynamic>> serviceResponse, List<UnSentCommentedImageOld> commImgs, int visitId){
    serviceResponse.forEach((element) {
      if(!_serviceReturnedCommImgIsOk(element, visitId))
        throw ServiceStatusErr(message: 'Servicio de guardar imágenes comentadas fallido.');
    });
  }

  static Future<List<CommentedImageOld>> getCommentedImages(String accessToken, int visitId)async{
    final List<Map<String, dynamic>> serviceResponse = await projectsService.getCommentedImages(accessToken, visitId);
    final List<CommentedImageOld> cmmImgs = commentedImagesFromJson(serviceResponse);
    return cmmImgs;
  } 

  static bool _serviceReturnedCommImgIsOk(Map<String, dynamic> jsonCommImg, int visitId){
    return jsonCommImg['visita_id'] == visitId && jsonCommImg['descripcion'] != null && jsonCommImg['ruta'] != null;
  }

  static Future updateFormInitialization(String accessToken, Position position, int formId)async{
    final Map<String, dynamic> body = {
      'latitud_inicio': position.latitude,
      'longitud_inicio': position.longitude
    };
    final Map<String, dynamic> serviceResponse = await projectsService.postFormInitialData(accessToken, body, formId);
    _throwServiceErrIfUpdateFormInitResponseIsntOk(serviceResponse);
  }

  static void _throwServiceErrIfUpdateFormInitResponseIsntOk(Map<String, dynamic> response){
    if(!_updateFormInitializationResponseIsOk(response))
      throw ServiceStatusErr(message: 'Ocurrió un problema al enviar la ubicación');
  }

  static bool _updateFormInitializationResponseIsOk(Map<String, dynamic> response){
      return response['latitud_inicio'] != null && response['longitud_inicio'] != null;
  }

  static Future updateFormFillingOutFinalization(String accessToken, Position position, int formId)async{
    final Map<String, dynamic> body = {
      'latitud_final': position.latitude,
      'longitud_final': position.longitude
    };
    final Map<String, dynamic> serviceResponse = await projectsService.postFormFinalData(accessToken, body, formId);
    _throwServiceErrIfUpdateFormFinalResponseIsntOk(serviceResponse);
  }

  static void _throwServiceErrIfUpdateFormFinalResponseIsntOk(Map<String, dynamic> response){
    if(!_updateFormFinalializationResponseIsOk(response))
      throw ServiceStatusErr(message: 'Ocurrió un problema al enviar la ubicación');
  }

  static bool _updateFormFinalializationResponseIsOk(Map<String, dynamic> response){
      return response['latitud_final'] != null && response['longitud_final'] != null;
  }
}