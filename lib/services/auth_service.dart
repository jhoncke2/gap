import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/services/basic_service.dart';

class AuthService extends BasicService{
  static final String _authUrl = BasicService.apiUrl + 'auth/';

  Future<Map<String, dynamic>> login(Map<String, dynamic> loginInfo)async{
    try{
      return await _tryLogin(loginInfo);
    }catch(err){
      throw ServiceStatusErr(message: 'Credenciales inválidas', extraInformation: 'login');
    }
  }

  Future <Map<String, dynamic>> _tryLogin(Map<String, dynamic> loginInfo)async{
    final String requestUrl = _authUrl + 'login';
    final Map<String, String> headers = { 'accept':'application/json' };
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(body: loginInfo, headers: headers);
    await executeGeneralEndOfRequest(requestType: RequestType.POST, headersAndBody: headersAndBody, requestUrl: requestUrl);
    return (currentResponseBody as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> refreshAuthToken(String oldToken)async{
    try{
      return await _tryRefreshAccessToken(oldToken);
    }on ServiceStatusErr catch(err){
      throw ServiceStatusErr(message: err.message, status: err.status, extraInformation: 'refresh_token');
    }
  }

  Future<Map<String, dynamic>> _tryRefreshAccessToken(String oldToken)async{
    final String requestUrl = _authUrl + 'refresh';
    final Map<String, String> headers = {'Authorization':'Bearer $oldToken'};
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers);
    await executeGeneralEndOfRequest(requestType: RequestType.POST, headersAndBody: headersAndBody, requestUrl: requestUrl);
    return (currentResponseBody as Map).cast<String, dynamic>();
  }
}

final AuthService authService = AuthService();