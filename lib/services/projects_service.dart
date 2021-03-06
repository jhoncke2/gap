import 'dart:convert';
import 'dart:io';

import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/services/basic_service.dart';

class ProjectsService extends BasicService{

  static final String _panelUrl = BasicService.apiUrl + 'panel/';

  Future<List<Map<String, dynamic>>> getProjects(String accessToken)async{
    final String requestUrl = _panelUrl + 'proyectos/visitas';
    final Map<String, String> headers = {
      'Authorization':'Bearer $accessToken'
    };
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers);
    await executeGeneralEndOfRequest(requestType: RequestType.GET, headersAndBody: headersAndBody, requestUrl: requestUrl);
    return (currentResponseBody as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> updateForm(String accessToken, List<Map<String, dynamic>> campos, int visitId)async{
    final String requestUrl = _panelUrl + 'visita-respuestas/$visitId';
    final Map<String, String> headers = {'Authorization':'Bearer $accessToken'};
    final Map<String, dynamic> body = {'respuestas':campos};
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: body);
    await executeGeneralEndOfRequest(requestType: RequestType.POST, headersAndBody: headersAndBody, requestUrl: requestUrl);
    return (currentResponseBody as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> saveFirmer(String accessToken, PersonalInformation firmer, int formId, int visitId)async{
    final String requestUrl = _panelUrl + 'visita-firmas/$visitId';
    final Map<String, String> headers = {'Authorization':'Bearer $accessToken', 'Content-Type':'application/x-www-form-urlencoded'};
    final Map<String, String> fields = firmer.toServiceJson();
    fields['formulario_g_formulario_id'] = formId.toString();
    final Map<String, dynamic> fileInfo = {
      'field_name':'photo',
      'file':firmer.firm
    };
    await executeMultiPartRequestWithOneFile(requestUrl, headers, fields, fileInfo);
    return (currentResponseBody as Map).cast<String, dynamic>();
  }

  Future<List<Map<String, dynamic>>> saveCommentedImages(String accessToken, List<File> imgFiles, List<String> commentaries, int visitId)async{
    final String requestUrl = _panelUrl + 'visita-fotos/$visitId';
    final Map<String, String> headers = {'Authorization':'Bearer $accessToken', 'Content-Type':'application/x-www-form-urlencoded'};
    final Map<String, String> fields = {'descriptions': jsonEncode(commentaries)};
    final Map<String, dynamic> filesInfo = {'files_field':'photos[]', 'files':imgFiles};
    await executeMultiPartRequestWithListOfFiles(requestUrl, headers, fields, filesInfo);
    return (currentResponseBody as List).cast<Map<String, dynamic>>();
  }
}

final ProjectsService projectsService = ProjectsService();