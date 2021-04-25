import 'dart:io';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource{
  //TODO: Cambiar por la ruta definitiva
  // ignore: non_constant_identifier_names
  final BASE_URL = 'dev.gapfergon.com';

  
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
} 