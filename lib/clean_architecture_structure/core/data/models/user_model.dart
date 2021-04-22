import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';

class UserModel extends User{
  UserModel({
    String email,
    String password
  }):super(
    email: email,
    password: password
  );

  factory UserModel.fromJson(Map<String, dynamic> json)=>UserModel(
    email: json['email'],
    password: json['password']
  );

  Map<String, dynamic> toJson()=>{
    'email':this.email,
    'password':this.password
  };
}