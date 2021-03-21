import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/services/auth_service.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;

class UserServicesManager{
  static Future login(String email, String password, BuildContext context)async{
    final Map<String, dynamic> loginInfo = { 'email':email, 'password':password };
    final String accessToken = await _obtainAccessToken(loginInfo);
    await _saveAccessToken(accessToken, context);
  }

  static Future loginOld(String email, String password, BuildContext context)async{
    try{
      await _tryLogin(email, password, context);
    }on ServiceStatusErr catch(err){
      await dialogs.showErrDialog(context, err.message);
    }catch(err){
      await dialogs.showErrDialog(context, err.toString());
    }
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