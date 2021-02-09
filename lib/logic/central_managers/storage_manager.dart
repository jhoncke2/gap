import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_storage_manager.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_storage_manager.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class StorageManager{
  static final StorageConnector _storageConnector = StorageConnectorSingleton.storageConnector;
  static void addCurrentActivityDataToBlocs(Map<BlocName, Bloc> blocs){
    blocs.forEach((blocName, bloc){
      _addCurrentActivityDataToBloc(blocName, bloc);
    });
  }

  static void _addCurrentActivityDataToBloc(BlocName name, Bloc bloc){
    switch(name){
      case BlocName.Projects:
        _addCurrentActivityDataToProjects(bloc);
        break;
      case BlocName.Visits:
        _addCurrentActivityDataToVisits(bloc);
        break;
      case BlocName.Formularios:
        _addCurrentActivityDataToFormularios(bloc);
        break;
      case BlocName.ChosenForm:
        _addCurrentActivityDataToChosenForm(bloc);
        break;
      case BlocName.Images:
        break;
      case BlocName.CommentedImages:
        _addCurrentActivityDataToCommentedImages(bloc);
        break;
      case BlocName.FirmPaint:
        break;
      case BlocName.Index:
        _addCurrentActivityDataToIndex(bloc);
        break;
    }
  }

  static Future<void> _addCurrentActivityDataToProjects(ProjectsBloc bloc)async{
    final ProjectsStorageManager psm = ProjectsStorageManager();
    final List<Project> projects = await psm.getProjects();
    final SetProjects spEvent = SetProjects(projects: projects);
    bloc.add(spEvent);
    final Project chosenOne = await psm.getChosenProject();
    final ChooseProject cpEvent = ChooseProject(chosenOne: chosenOne);
    bloc.add(cpEvent);
  }

  static Future<void> _addCurrentActivityDataToVisits(VisitsBloc bloc)async{
    final VisitsStorageManager vsm = VisitsStorageManager();
    final List<Visit> visits = await vsm.getVisits();
    final SetVisits svEvent = SetVisits(visits: visits);
    bloc.add(svEvent);
    final Visit chosenOne = await vsm.getChosenVisit();
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: chosenOne);
    bloc.add(cvEvent);
  }

  static Future<void> _addCurrentActivityDataToFormularios(FormulariosBloc bloc)async{
    final FormulariosStorageManager fsm = FormulariosStorageManager();
    final List<Formulario> forms = await fsm.getForms();
    final SetForms sfEvent = SetForms(forms: forms);
    bloc.add(sfEvent);
  }

  static Future<void> _addCurrentActivityDataToChosenForm(ChosenFormBloc bloc)async{
    final ChosenFormStorageManager cfsm = ChosenFormStorageManager();
    final Formulario chosenOne = await cfsm.getChosenForm();
    final InitFormFillingOut iffoEvent= InitFormFillingOut(formulario: chosenOne);
    bloc.add(iffoEvent);
  }

  static Future<void> _addCurrentActivityDataToCommentedImages(CommentedImagesBloc bloc)async{
    final CommentedImagesStorageManager cmsm = CommentedImagesStorageManager();
    final List<CommentedImage> commentedImages = await cmsm.getCommentedImages();
    final SetCommentedImages sciEvent = SetCommentedImages(commentedImages: commentedImages);
    bloc.add(sciEvent);
  }

  static Future<void> _addCurrentActivityDataToIndex(IndexBloc bloc)async{

  }
}