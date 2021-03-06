import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gap/errors/services/service_status_err.dart';
enum RequestType{
  GET,
  POST,
  PUT,
  DELETE
}

abstract class BasicService{
  static final String apiUrl = 'https://gapfergon.com/api/';
  /** 
   * Variable usada en todas las sub-funciones en los que se está haciendo una petición al servidor, 
   * para guardar la respuesta del servidor, momentaneamente, para luego ser retornada desde la
   * función principal.
   */
  dynamic currentResponseBody;
//for testing
  http.Response currentResponse;
  String executedServiceFunction;
//
  http.MultipartRequest createMultiPartPostRequest(String url){
    return http.MultipartRequest('POST', Uri.parse(url));
  }

  Future executeMultiPartRequestWithOneFile(String requestUrl, Map<String, String> headers, Map<String, String> fields, Map<String, dynamic> fileInfo)async{
    final http.MultipartRequest request = await _generateMultiPartRequestWithOneFile(requestUrl, headers, fields, fileInfo);
    await _sendMultiPartRequest(request);
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

  http.MultipartRequest _generateBasicMultiPartRequest(String requestUrl, Map<String, String> headers, Map<String, String> fields){
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse(requestUrl)
    );
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    return request;
  }

  Future _sendMultiPartRequest(http.MultipartRequest request)async{
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    formatServerResponse(response);
  }

  Future executeMultiPartRequestWithListOfFiles(String requestUrl, Map<String, String> headers, Map<String, String> fields, Map<String, dynamic> filesInfo )async{
    final http.MultipartRequest request = _generateBasicMultiPartRequest(requestUrl, headers, fields);
    _addFilesToRequest(filesInfo, request);
    await _sendMultiPartRequest(request);
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
  

  Map<String, Map<String, dynamic>> createHeadersAndBodyForARequest({Map<String, String> headers, Map<String, dynamic> body}){
    return {
      'headers':headers??{},
      'body':body??{}
    };
  }

  Future<void> executeGeneralRequestWithoutHeaders(Map<String, dynamic> bodyData, String route, RequestType requestType)async{
    final Map<String, Map<String, dynamic>> headersAndBody = {
      'headers': {
      },
      'body': bodyData
    };
    await executeGeneralEndOfRequest(requestType: RequestType.POST, requestUrl: route, headersAndBody: headersAndBody);
  }

  /**
   * Ejecuta la parte final de un request
   * (Es igual para casi todos los requests)
   */
  Future<void> executeGeneralEndOfRequest({@required RequestType requestType, @required String requestUrl, @required Map<String, dynamic> headersAndBody})async{    
    switch(requestType){
      case RequestType.GET:
        await executeGeneralEndOfGETRequest(requestUrl: requestUrl, headersAndBody: headersAndBody);
      break;
      case RequestType.POST:
        await executeGeneralEndOfPOSTRequest(requestUrl: requestUrl, headersAndBody: headersAndBody);
      break;
      case RequestType.PUT:
        await executeGeneralEndOfPUTRequest(requestUrl: requestUrl, headersAndBody: headersAndBody);
      break;
      case RequestType.DELETE:
        await executeGeneralEndOfDELETERequest(requestUrl: requestUrl, headersAndBody: headersAndBody);
      break;
    };    
  }

  Future<void> executeGeneralEndOfGETRequest({@required String requestUrl, @required Map<String, dynamic> headersAndBody})async{
    this.executedServiceFunction = 'get';//for testing
    final http.Response serverResponse = await http.get(
      requestUrl,
      headers: ((headersAndBody['headers']).cast<String, String>())??{},
    );
    //for testing:
    _doTestInstantiations('get', serverResponse);
    //
    formatServerResponse(serverResponse);
  }

  Future<void> executeGeneralEndOfPOSTRequest({@required String requestUrl, @required Map<String, Map<String, dynamic>> headersAndBody})async{
    this.executedServiceFunction = 'post';//for testing
    headersAndBody['headers']['Content-Type'] = 'application/json';
    final http.Response serverResponse = await http.post(
      requestUrl,
      headers: ((headersAndBody['headers']).cast<String, String>())??{},
      body:json.encode( headersAndBody['body'] )
    );
    //for testing:
    _doTestInstantiations('post', serverResponse);
    //
    formatServerResponse(serverResponse);
  }
  
  Future<void> executeGeneralEndOfPUTRequest({@required String requestUrl, @required Map<String, dynamic> headersAndBody})async{
    this.executedServiceFunction = 'put';//for testing
    final http.Response serverResponse = await http.put(
      requestUrl,
      headers: ((headersAndBody['headers']).cast<String, String>())??{},
      body:headersAndBody['body']
    );
    //for testing:
    _doTestInstantiations('put', serverResponse);
    //
    formatServerResponse(serverResponse);
  }
  
  Future<void> executeGeneralEndOfDELETERequest({@required String requestUrl, @required Map<String, dynamic> headersAndBody})async{
    this.executedServiceFunction = 'delete';//for testing
    final http.Response serverResponse = await http.delete(
      requestUrl,
      headers: ((headersAndBody['headers']).cast<String, String>())??{},
    );
    //for testing:
    _doTestInstantiations('delete', serverResponse);
    //
    formatServerResponse(serverResponse);
  }

  void _doTestInstantiations(String tipoDeServicio, http.Response serverResponse){
    this.executedServiceFunction = tipoDeServicio;
    this.currentResponse = serverResponse;
  }
  
  @protected
  void formatServerResponse(http.Response serverResponse){
    _tryCurrentResponseBodyConvertion(serverResponse);
    _throwExceptionIfResponseBodyHasErrorField();
  }
  
  void _tryCurrentResponseBodyConvertion(http.Response serverResponse){
    try{
      currentResponseBody = json.decode(serverResponse.body);
    }catch(err){
      throw ServiceStatusErr(status: serverResponse.statusCode, message: serverResponse.reasonPhrase, extraInformation: serverResponse.reasonPhrase);
    }
  }

  void _throwExceptionIfResponseBodyHasErrorField(){
    if(_currentResponseBodyHasErrorAsMap())
        throw ServiceStatusErr(status: currentResponseBody['code'], extraInformation: currentResponseBody['error']);
  }

  bool _currentResponseBodyHasErrorAsMap(){
    return currentResponseBody is Map && (currentResponseBody['error'] != null || currentResponseBody['errors'] != null);
  }
}