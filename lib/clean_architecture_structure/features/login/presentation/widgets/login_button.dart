import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/user/user_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/utils/dialogs.dart' as dialogs;
import 'package:gap/old_architecture/data/enums/enums.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  LoginButton({
    Key key,
    @required this.emailController,    
    @required this.passwordController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (blocContext, state){
        _definePostFrameCallBackByStateType(state, blocContext);
        return GeneralButton(
          text: 'INGRESAR',
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: ( [UserLoading, UserLogged].contains( state.runtimeType ) )? null : ()=>_login(blocContext)//(state.loginButtonIsAvaible) ? _login : null,
        );
      },
    );
  }

  void _definePostFrameCallBackByStateType(UserState state, BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(state is UserLogged){
        BlocProvider.of<NavigationBloc>(context).add(NavigateReplacingAllToEvent(navigationRoute: NavigationRoute.Projects));
        Navigator.of(context).pushReplacementNamed(NavigationRoute.Projects.value);
      }
      else if(state is UserError)
        _showErrorDialog(state.message);
    });
  }

  void _showErrorDialog(String message){
    WidgetsBinding.instance.addPostFrameCallback((_){
      dialogs.showTemporalDialog(message);
    });
  }

  void _login(BuildContext blocContext) async {    
    BlocProvider.of<UserBloc>(blocContext).add(
      LoginEvent(email: emailController.text, password: passwordController.text)
    );
  }
}