import 'package:bloc/bloc.dart';
import 'package:gap/data/enums/enums.dart';

class DataSourceManager{

  static final Map<BlocName, Bloc> _blocs = {};

  static set blocs(Map<BlocName, Bloc> blocs){
    blocs.forEach((blocName, bloc) {
      _blocs[blocName] = bloc;
    });
  }

  static void changeDataSource(String dataSource){
    _blocs.forEach((key, value) {
      switch(key){
        case BlocName.Projects:
          // TODO: Handle this case.
          break;
        case BlocName.Visits:
          // TODO: Handle this case.
          break;
        case BlocName.Formularios:
          // TODO: Handle this case.
          break;
        case BlocName.ChosenForm:
          // TODO: Handle this case.
          break;
        case BlocName.Images:
          // TODO: Handle this case.
          break;
        case BlocName.CommentedImages:
          // TODO: Handle this case.
          break;
        case BlocName.FirmPaint:
          // TODO: Handle this case.
          break;
        case BlocName.Index:
          // TODO: Handle this case.
          break;
      }
    });
  }
  
}