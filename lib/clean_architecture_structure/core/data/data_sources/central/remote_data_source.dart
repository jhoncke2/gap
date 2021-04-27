import 'dart:io';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource{
  //TODO: Cambiar por la ruta definitiva
  // ignore: non_constant_identifier_names
  final BASE_URL = 'dev.gapfergon.com';
  
  static const BASE_API_UNCODED_PATH = 'api';
  // ignore: non_constant_identifier_names
  final BASE_PANEL_UNCODED_PATH = '$BASE_API_UNCODED_PATH/panel/';
  // ignore: non_constant_identifier_names
  final BASE_AUTH_UNCODED_PATH = '$BASE_API_UNCODED_PATH/auth/';

  Map<String, String> createSingleAuthorizationHeaders(String accessToken){
    return {
      'Authorization':'Bearer $accessToken'
    };
  }

  Map<String, String> createAuthorizationJsonHeaders(String accessToken){
    return {
      'Authorization':'Bearer $accessToken',
      'Content-Type':'application/json'
    };
  }
  
}

abstract class RemoteDataSourceWithMultiPartRequests extends RemoteDataSource{

  Future<http.Response> executeMultiPartRequestWithListOfFiles(String requestUrl, Map<String, String> headers, Map<String, String> fields, Map<String, dynamic> filesInfo )async{
    final http.MultipartRequest request = _generateBasicMultiPartRequest(requestUrl, headers, fields);
    _addFilesToRequest(filesInfo, request);
    return await _sendMultiPartRequest(request);
  }

  http.MultipartRequest _generateBasicMultiPartRequest(String requestUrl, Map<String, String> headers, Map<String, String> fields){
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse(requestUrl)
    );
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    return request;
  }

  void _addFilesToRequest(Map<String, dynamic> filesInfo , http.MultipartRequest request){
    final List<File> files = filesInfo['files'];
    request.files.addAll(files.map((File file){
      return _getMultipartFileFromFile(file, filesInfo['files_field']);
    }));
  }

  http.MultipartFile _getMultipartFileFromFile(File file, String multiPartFileName){
    return http.MultipartFile(
      multiPartFileName,
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path.split('/').last
    );
  }

  Future<http.Response> _sendMultiPartRequest(http.MultipartRequest request)async{
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    return response;
  }

  Future executeMultiPartRequestWithOneFile(String requestUrl, Map<String, String> headers, Map<String, String> fields, Map<String, dynamic> fileInfo)async{
    final http.MultipartRequest request = await _generateMultiPartRequestWithOneFile(requestUrl, headers, fields, fileInfo);
    final response = await _sendMultiPartRequest(request);
    return response;
  }

  Future<http.MultipartRequest> _generateMultiPartRequestWithOneFile(String requestUrl, Map<String, String> headers, Map<String, String> fields, Map<String, dynamic> fileInfo)async{
    final http.MultipartRequest request = _generateBasicMultiPartRequest(requestUrl, headers, fields);
    final File file = fileInfo['file'];
    request.files.add(http.MultipartFile(
      fileInfo['field_name'],
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path.split('/').last
    ));
    return request;
  }
} 