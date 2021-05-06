import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/user/user_bloc.dart';

import '../../../../injection_container.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => sl(),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (blocContext, state) {
          if(state is UserLoading)
            return Container();
          else{
            return IconButton(
              color: Theme.of(context).primaryColor,
              iconSize: 32,
              icon: Icon(Icons.logout),
              onPressed: () {
                //PagesNavigationManager.navToLogin();
                BlocProvider.of<UserBloc>(blocContext).add(
                  LogoutEvent()
                );
              },
            );
          }
        },
      )
    );
  }
}
