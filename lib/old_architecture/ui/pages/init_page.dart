import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/old_architecture/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/old_architecture/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';

// ignore: must_be_immutable
class InitPage extends StatelessWidget{

  static final String route = 'init';
  static StreamController<BuildContext> _contextStreamController = StreamController();
  static Stream<BuildContext> get contextStream => _contextStreamController.stream;
  BuildContext context;

  @override
  Widget build(BuildContext context){
    _doInitialConfig(context);
    return Scaffold(
      //backgroundColor: Colors.white,
      body: NativeBackButtonLocker(
        child: Container(
          child: Center(
            child: Image.asset(
              'assets/logos/logo_con_nombre.png',
              height: 200,
              width: 200,
              fit: BoxFit.fill
            ),
          ),
        ),
      ),
    );
  }

  void _doInitialConfig(BuildContext context){
    context = context;
    _initSizeUtils(context);
    _initBlocsManagers(context);    
  }
  
  void _initSizeUtils(context){
    final Size screenSize = MediaQuery.of(context).size;
    SizeUtils sizeUtils = SizeUtils();
    sizeUtils.initUtil(screenSize);
  }

  void _initBlocsManagers(BuildContext context){
    CommentedImagesIndexManagerSingleton(appContext: context);
    ChosenFormManagerSingleton(appContext: context);
  }
}