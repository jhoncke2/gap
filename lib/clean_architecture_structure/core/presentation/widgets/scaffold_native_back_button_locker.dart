import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ScaffoldNativeBackButtonLocker extends StatelessWidget {
  final Widget child;
  final List<BlocProvider> providers;
  ScaffoldNativeBackButtonLocker({
    Key key, 
    @required this.child,
    this.providers
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(create: (_)=>sl()),
          BlocProvider<KeyboardListenerBloc>(create: (_)=>sl())
        ]..addAll(this.providers??[]),
        child: WillPopScope(
            child: child,
            onWillPop: () async {
              return false;
            }),
      ),
    );
  }
}
