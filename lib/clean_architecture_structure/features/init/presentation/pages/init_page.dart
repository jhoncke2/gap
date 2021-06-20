import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/preloaded_data/preloaded_data_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_app_scaffold.dart';
import '../../../../injection_container.dart';

class InitPage extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  const InitPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sizeUtils.initUtil(MediaQuery.of(context).size);
    _addPostFrameFunction(context);
    return GeneralAppScaffold(
      createChild: ()=> Container(
          height: MediaQuery.of(context).size.height * 0.975,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Image.asset(
                'assets/logos/logo_con_nombre.png',
                height: 200,
                width: 200,
                fit: BoxFit.fill
              ),
              Text(
                'Versión 0.14.21',
                style: TextStyle(
                  color: Theme.of(context).primaryColor.withOpacity(0.65),
                  fontSize: 16.5
                ),
              )
            ],
          ),
        )
    );
  }

  void _addPostFrameFunction(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sl<PreloadedDataBloc>().add(SendPreloadedDataEvent());
    });
  }
}