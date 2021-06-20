import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/preloaded_data/preloaded_data_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable
class GeneralAppScaffold extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  final Widget child;
  final Widget Function() createChild;
  final List<BlocProvider> providers;
  BuildContext context;
  GeneralAppScaffold({
    Key key,
    this.child,
    @required this.createChild,
    this.providers
  }) : 
    super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(create: (_)=>sl()),
          BlocProvider<PreloadedDataBloc>(create: (_)=>sl()),
          BlocProvider<KeyboardListenerBloc>(create: (_)=>sl())
        ]..addAll(this.providers??[]),
        child: WillPopScope(
          child: BlocBuilder<PreloadedDataBloc, PreloadedDataState>(
            builder: (_, state){
              if(state is InactivePreloaded)
                return _createNavigationBuilder();
              else if(state is SendingPreloaded)
                return _createStackWidget(_createSendingPreloadedDataWidget());
              else if(state is SuccessfulySentPreloaded)
                return _createStackWidget(_createSentPreloadedData());
              else
                return _createStackWidget(_createSentPreloadedError());
            },
          ),
          onWillPop: () async {
            return false;
          }
        ),
      ),
    );
  }
  
  Widget _createStackWidget(Widget upperWidget){
    return Stack(
      children: [
        this.createChild(),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.withOpacity(0.25),
        ),
        upperWidget
      ],
    );
  }

  Widget _createNavigationBuilder(){
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        if(state is InactiveNavigation)
          return this.createChild();
        else if(state is Popped){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context).pushReplacementNamed(state.navRoute.value);
          });
        }
        return Container();
      },
    );
  }

  Widget _createSendingPreloadedDataWidget(){
    return _centerMessage(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _createText('Enviando información precargada'),
          CustomProgressIndicator(heightScreenPercentage: 0.1)
        ],
      )
    );
  }

  Widget _createSentPreloadedData(){
    return _centerMessage(
      child: _createText( 'Se ha enviado exitosamente la información precargada')
    );
  }

  Widget _createSentPreloadedError(){
    return _centerMessage(
      child: _createText( 'Ocurrió un error al enviar la información precargada')
    );
  }

  Widget _createText(String text){
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: sizeUtils.subtitleSize,
          color: Theme.of(context).primaryColor
        ),
      ),
    );
  }

  Widget _centerMessage({ @required Widget child } ){
    return Center(
      child: Container(
        child: child,
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.symmetric(
          horizontal: sizeUtils.xasisSobreYasis * 0.035
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.975),
          borderRadius: BorderRadius.circular(15)
        ),
      ),
    );
  }
}