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

  Future<Map<String, dynamic>> updateForm(String accessToken, List<Map<String, dynamic>> campos, int visitId)async{
    final String requestUrl = _panelUrl + 'visita-respuestas/$visitId';
    final Map<String, String> headers = {'Authorization':'Bearer $accessToken'};
    final Map<String, dynamic> body = {'respuestas':campos};
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: body);
    await executeGeneralEndOfRequest(requestType: RequestType.POST, headersAndBody: headersAndBody, requestUrl: requestUrl);
    return (currentResponseBody as Map).cast<String, dynamic>();
  }
}

final ProjectsService projectsService = ProjectsService();