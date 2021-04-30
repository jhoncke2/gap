import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/user_model.dart';

abstract class UserLocalDataSource{
  Future<void> setUserInformation(UserModel user);
  Future<UserModel> getUserInformation();
  Future<void> setAccessToken(String accessToken);
  Future<String> getAccessToken();
  
}

class UserLocalDataSourceImpl implements UserLocalDataSource{
  static const String USER_STORAGE_KEY = 'user';
  static const String ACCESS_TOKEN_STORAGE_KEY = 'access_token';
  static const String APP_HAS_RUNNED_BEFORE_STORAGE_KEY = 'app_has_runned_before';
  final StorageConnector storageConnector;

  UserLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setUserInformation(UserModel user)async{
    await storageConnector.setMap(user.toJson(), USER_STORAGE_KEY);
  }

  @override
  Future<UserModel> getUserInformation()async{
    final Map<String, dynamic> jsonUser = await storageConnector.getMap(USER_STORAGE_KEY);
    return UserModel.fromJson(jsonUser);
  }

  @override
  Future<void> setAccessToken(String accessToken)async{
    await storageConnector.setString(accessToken, ACCESS_TOKEN_STORAGE_KEY);
  }

  @override
  Future<String> getAccessToken()async{
    return await storageConnector.getString(ACCESS_TOKEN_STORAGE_KEY);
  }
}