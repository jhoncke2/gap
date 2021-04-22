import 'package:gap/clean_architecture_structure/core/data/models/user_model.dart';

abstract class UserLocalDataSource{
  Future<void> setUserInformation(UserModel user);
  Future<UserModel> getUserInformation();
  Future<void> setAccessToken();
  Future<String> getAccessToken();
}