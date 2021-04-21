import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/old_architecture/services/auth_service.dart';

class UserServicesManager{
  static Future login(String email, String password, BuildContext context)async{
    final Map<String, dynamic> loginInfo = { 'email':email, 'password':password };
    final String accessToken = await _obtainAccessToken(loginInfo);
    await _saveAccessToken(accessToken, context);
  }

  static Future _tryLogin(String email, String password, BuildContext context)async{
    
    //await PagesNavigationManager.navToProjects();
  }

  static Future<String> _obtainAccessToken(Map<String, dynamic> loginInfo)async{
    final Map<String, dynamic> loginResponse = await authService.login(loginInfo);
    final Map<String, dynamic> originalData = loginResponse['data']['original'];
    final String accessToken = originalData['access_token'];
    return accessToken;
  }

  static Future _saveAccessToken(String accessToken, BuildContext context)async{
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.add(SetAccessToken(accessToken: accessToken));
    await UserStorageManager.setAccessToken(accessToken);
  }
}