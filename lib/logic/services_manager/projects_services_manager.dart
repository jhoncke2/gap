import 'dart:io';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/services/projects_service.dart';

class ProjectsServicesManager{

  Future<List<Project>> loadProjects(ProjectsBloc bloc, String accessToken)async{
    final List<Map<String, dynamic>> projectsResponse = await projectsService.getProjects(accessToken);
    final List<Project> projects = projectsFromJson(projectsResponse);
    return projects;
  }

  static Future updateForm(Formulario form, int visitId, String accessToken)async{
    final List<Map<String, dynamic>> formattedFormCampos = _getFormattedFormCampos(form);
    final List<Map<String, dynamic>> response = await projectsService.updateForm(accessToken, formattedFormCampos, visitId);
    _throwErrIsUpdateFormIsntOk(response, formattedFormCampos);
  }

  static List<Map<String, dynamic>> _getFormattedFormCampos(Formulario form){
    final List<Map<String, dynamic>> jsonCampos = [];
    for(CustomFormField cff in form.campos)
      if(cff is VariableFormField)
        _addVariableFormFieldToList(cff, jsonCampos, form.id); 
    return jsonCampos;
  }

  static void _addVariableFormFieldToList(VariableFormField vff, List<Map<String, dynamic>> jsonCampos, int formId){
    final Map<String, dynamic> jsonCff = _getServiceJsonByVariableFormField(vff, formId);
    _defineFormFieldValuesByTypeOfValues(vff, jsonCff);
    jsonCampos.add(jsonCff);
  }

  static Map<String, dynamic> _getServiceJsonByVariableFormField(VariableFormField vff, int formId){
    return {
      'formulario_g_formulario_id':formId,
      'name':vff.name
    };
  }

  static void _throwErrIsUpdateFormIsntOk(List<Map<String, dynamic>> response, List<Map<String, dynamic>> formattedFormCampos){
    if(!_updateFormResponseIsOk(response, formattedFormCampos))
      throw ServiceStatusErr(message: 'El servicio de enviar el formulario no se efectuó correctamente');
  }

  static bool _updateFormResponseIsOk(List<Map<String, dynamic>> response, List<Map<String, dynamic>> formattedFormCampos){
    return response.length == formattedFormCampos.length;
  }

  static void _defineFormFieldValuesByTypeOfValues(VariableFormField vff, Map<String, dynamic> jsonVff){
    if(vff is SingleValueFormField){
      jsonVff['res'] = [vff.uniqueValue];
    }else if(vff is MultiValueFormField){
      jsonVff['res'] = (vff.values.where((element) => element.selected)).map<String>((e) => e.value).toList();
    }
  }

  static Future saveFirmer(String accessToken, PersonalInformation firmer, int formId, int visitId)async{
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

  static Future saveCommentedImages(String accessToken, List<CommentedImage> commentedImages, int visitId)async{
    final List<File> imgFiles = [];
    final List<String> imgCommentaries = [];
    _separateImgsAndComments(commentedImages, imgFiles, imgCommentaries);
    final List<Map<String, dynamic>> serviceResponse = await projectsService.saveCommentedImages(accessToken, imgFiles, imgCommentaries, visitId);
    _throwErrIfSaveCommImgsFailed(serviceResponse, commentedImages, visitId);
  }

  static void _separateImgsAndComments(List<CommentedImage> commentedImages, List<File> files, List<String> comments){
    commentedImages.forEach((commImg) {
      files.add(commImg.image);
      comments.add(commImg.commentary);
    });
  }

  static void _throwErrIfSaveCommImgsFailed(List<Map<String, dynamic>> serviceResponse, List<CommentedImage> commImgs, visitId){
    if(serviceResponse.length!=commImgs.length)
      throw ServiceStatusErr(message: 'Servicio de guardar imágemnes comentadas incompleto.');
    _evaluateIfAllReturnedCommImgsAreOk(serviceResponse, commImgs, visitId);
  }

  static void _evaluateIfAllReturnedCommImgsAreOk(List<Map<String, dynamic>> serviceResponse, List<CommentedImage> commImgs, int visitId){
    serviceResponse.forEach((element) {
      if(!_serviceReturnedCommImgIsOk(element, visitId))
        throw ServiceStatusErr(message: 'Servicio de guardar imágenes comentadas fallido.');
    });
  }

  static bool _serviceReturnedCommImgIsOk(Map<String, dynamic> jsonCommImg, int visitId){
    return jsonCommImg['visita_id'] == visitId && jsonCommImg['descripcion'] != null && jsonCommImg['ruta'] != null;
  }
}