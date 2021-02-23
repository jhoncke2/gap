import 'package:gap/services/basic_service.dart';

class AuthService extends BasicService{
  static final String _authUrl = BasicService.apiUrl + 'auth/';

  Future<Map<String, dynamic>> login(Map<String, dynamic> loginInfo)async{
    final String requestUrl = _authUrl + 'login';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(body: loginInfo);
    await executeGeneralEndOfRequest(requestType: RequestType.POST, headersAndBody: headersAndBody, requestUrl: requestUrl);
    return currentResponseBody;
  }
}

final AuthService authService = AuthService();