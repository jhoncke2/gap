import 'package:flutter/material.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/ui/pages/login_page.dart';
import 'package:gap/ui/utils/size_utils.dart';
class InitPage extends StatelessWidget {
  static final route = 'init';
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _addPostFrameCallBack();
    return Scaffold(
      body: Container(),
    );
  }

  void _addPostFrameCallBack(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      _validateInitialConfiguration();
      _navigateToFirstPage();
    });
  }

  void _validateInitialConfiguration(){
    _initSizeUtils();
    initBlocsManagers();
  }

  void _initSizeUtils(){
    final SizeUtils sizeUtils = SizeUtils();
    final Size screenSize = MediaQuery.of(_context).size;
    sizeUtils.initUtil(screenSize);
  }

  void initBlocsManagers(){
    CommentedImagesIndexManagerSingleton(appContext: _context);
    ChosenFormManagerSingleton(appContext: _context);
  }

  void _navigateToFirstPage(){
    Navigator.of(_context).pushReplacementNamed(LoginPage.route);
  }
}