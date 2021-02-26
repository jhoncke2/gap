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
}

final ProjectsService projectsService = ProjectsService();