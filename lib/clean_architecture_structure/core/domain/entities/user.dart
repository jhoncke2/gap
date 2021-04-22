import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String email;
  final String password;

  User({
    @required this.email, 
    @required this.password
  });

  @override
  List<Object> get props => [this.email, this.password];

}