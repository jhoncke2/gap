import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/user/user_bloc.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import '../../../../injection_container.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (_)=>sl()),
        BlocProvider<NavigationBloc>(create: (_)=>sl()),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (blocContext, state) {
          return _createUserBuilderWidget(blocContext, state);
        },
      )
    );
  }

  Widget _createUserBuilderWidget(BuildContext context, UserState state){
    if(state is UserLoading)
      return Container();
    else if(state is UserLogouted){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp){ 
        BlocProvider.of<NavigationBloc>(context).add(NavigateReplacingAllToEvent(navigationRoute: NavigationRoute.Login));
        Navigator.of(context).pushReplacementNamed(NavigationRoute.Login.value);
      });
      return Container();
    }
    else{
      return IconButton(
        color: Theme.of(context).primaryColor,
        iconSize: 32,
        icon: Icon(Icons.logout),
        onPressed: () {
          //PagesNavigationManager.navToLogin();
          BlocProvider.of<UserBloc>(context).add(
            LogoutEvent()
          );
        },
      );
    }
  }
}