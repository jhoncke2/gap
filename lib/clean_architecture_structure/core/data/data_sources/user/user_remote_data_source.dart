import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/data/data_sources/central/remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/core/data/models/user_model.dart';

abstract class UserRemoteDataSource{
  Future<String> login(UserModel user);
  Future<String> refreshAccessToken(String oldAccessToken);
}

class UserRemoteDataSourceImpl extends RemoteDataSource implements UserRemoteDataSource{
  static const LOGIN_URL = 'login';
  static const REFRESH_ACCESS_TOKEN_URL = 'refresh';

  final http.Client client;

  UserRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<String> login(UserModel user)async{
    try{
      final Map<String, dynamic> body = user.toJson();
      final response = await client.post(
        Uri.http(super.BASE_URL, '${super.BASE_AUTH_UNCODED_PATH}$LOGIN_URL'),
        body: body
      );
      if(response.statusCode != 200)
        throw Exception();
      return _getAccessTokenFromResponse(response);
    }catch(exception){
      throw ServerException(type: ServerExceptionType.LOGIN, message: 'Credenciales inválidas');
    }
  }

  @override
  Future<String> refreshAccessToken(String oldAccessToken)async{
    final response = await client.post(
      Uri.http(super.BASE_URL, '${super.BASE_AUTH_UNCODED_PATH}$REFRESH_ACCESS_TOKEN_URL'),
      headers: createAuthorizationJsonHeaders(oldAccessToken)
    );
    return _getAccessTokenFromResponse(response);
  }

  String _getAccessTokenFromResponse(http.Response response){
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final String accessToken = responseBody['data']['original']['access_token'];
    return accessToken;
  }
}