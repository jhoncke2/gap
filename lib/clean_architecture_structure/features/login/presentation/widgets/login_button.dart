import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/user/user_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/utils/dialogs.dart' as dialogs;
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
        _showErrorDialogIfThereIsAny(state);
        return GeneralButton(
          text: 'INGRESAR',
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (state is UserLoading)? null : ()=>_login(blocContext)//(state.loginButtonIsAvaible) ? _login : null,
        );
      },
    );
  }

  void _showErrorDialogIfThereIsAny(UserState state){
    if(state is UserError)
      _showErrorDialog(state.message);
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