import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_storage_manager.dart';
import 'package:gap/logic/bloc/entities/formularios/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_storage_manager.dart';
import 'package:gap/logic/bloc/entities/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_storage_manager.dart';

class StorageManager{
  static final _StorageBlocsManager _storageRecentActivityBlocManager = _StorageRecentActivityBlocsManager();
  static final _StorageBlocsManager _storagePreloadedDataBlocManager = _StoragePreloadedDataBlocsManager();

  static void addRecientActivityDataToBlocs(Map<BlocName, Bloc> blocs){
    _storageRecentActivityBlocManager.addStorageDataToBlocs(blocs);
  }

  static void addPreloadedDataToBlocs(Map<BlocName, Bloc> blocs){
    _storagePreloadedDataBlocManager.addStorageDataToBlocs(blocs);
  }
}



abstract class _StorageBlocsManager{
  @protected
  Map<BlocName, Bloc> blocs;

  void addStorageDataToBlocs(Map<BlocName, Bloc> blocs){
    this.blocs = blocs;
    blocs.forEach((blocName, bloc){
      _addStorageDataToBloc(blocName, bloc);
    });
  }

  void _addStorageDataToBloc(BlocName name, Bloc bloc){
    switch(name){
      case BlocName.Projects:
        addStorageDataToProjectsBloc(bloc);
        break;
      case BlocName.Visits:
        addStorageDataToVisitsBloc(bloc);
        break;
      case BlocName.Formularios:
        addStorageDataToFormulariosBloc(bloc);
        break;
      case BlocName.ChosenForm:
        addStorageDataToChosenFormBloc(bloc);
        break;
      case BlocName.Images:
        break;
      case BlocName.CommentedImages:
        addStorageDataToCommentedImagesBloc(bloc);
        break;
      case BlocName.FirmPaint:
        break;
      case BlocName.Index:
        //TODO: Arreglar problema con index null desde storage
        //addStorageDataToIndexBloc(bloc);
        break;
    }
  }

  @protected
  Future<void> addStorageDataToProjectsBloc(ProjectsBloc bloc)async{
    await addStorageDataToProjects(bloc);
    await _addStorageDataToChosenProject(bloc);
  }

  @protected
  Future<void> addStorageDataToProjects(ProjectsBloc bloc)async{}

  Future<void> _addStorageDataToChosenProject(ProjectsBloc bloc)async{
    final Project chosenOne = await ProjectsStorageManager.getChosenProject();
    final ChooseProject cpEvent = ChooseProject(chosenOne: chosenOne);
    bloc.add(cpEvent);
  }

  @protected
  Future<void> addStorageDataToVisitsBloc(VisitsBloc vBloc)async{
    await addStorageDataToVisits(vBloc);
    await _addStorageDataToChosenVisit(vBloc);
  }

  @protected
  Future<void> addStorageDataToVisits(VisitsBloc bloc)async{}

  Future<void> _addStorageDataToChosenVisit(VisitsBloc bloc)async{
    final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: chosenOne);
    bloc.add(cvEvent);
  }

  @protected
  Future<void> addStorageDataToFormulariosBloc(FormulariosBloc bloc)async{}

  @protected
  Future<void> addStorageDataToChosenFormBloc(ChosenFormBloc bloc)async{
    final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
    final InitFormFillingOut iffoEvent= InitFormFillingOut(formulario: chosenOne);
    bloc.add(iffoEvent);
  }

  @protected
  Future<void> addStorageDataToCommentedImagesBloc(CommentedImagesBloc bloc)async{
    final List<CommentedImage> commentedImages = await CommentedImagesStorageManager.getCommentedImages();
    final SetCommentedImages sciEvent = SetCommentedImages(commentedImages: commentedImages);
    bloc.add(sciEvent);
  }

  @protected
  Future<void> addStorageDataToIndexBloc(IndexBloc bloc)async{
    final IndexStorageManager ism = IndexStorageManager();
    final IndexState indexConfig = await ism.getIndexConfig();
    final int nPages = indexConfig.nPages;
    final ChangeNPages cnpEvent = ChangeNPages(nPages: nPages);
    bloc.add(cnpEvent);
    final int newIndexPage = indexConfig.currentIndexPage;
    final ChangeIndexPage ciEvent = ChangeIndexPage(newIndexPage: newIndexPage);
    bloc.add(ciEvent);
  }
}



class _StorageRecentActivityBlocsManager extends _StorageBlocsManager{

  @override
  Future<void> addStorageDataToVisits(VisitsBloc bloc)async{
    final List<Visit> visits = await VisitsStorageManager.getVisits();
    final SetVisits svEvent = SetVisits(visits: visits);
    bloc.add(svEvent);
  }

  @override
  Future<void> addStorageDataToFormulariosBloc(FormulariosBloc bloc)async{
    final List<Formulario> forms = await FormulariosStorageManager.getForms();
    final SetForms sfEvent = SetForms(forms: forms);
    bloc.add(sfEvent);
  }
}



class _StoragePreloadedDataBlocsManager extends _StorageBlocsManager{

  @override
  Future<void> addStorageDataToProjects(ProjectsBloc bloc)async{
    final List<Project> projectsWithPreloadedVisits = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final SetProjects spEvent = SetProjects(projects: projectsWithPreloadedVisits);
    bloc.add(spEvent);
  }

  @override
  Future<void> addStorageDataToVisits(VisitsBloc vBloc)async{
    final ProjectsState pState = super.blocs[BlocName.Projects].state;
    if(pState.chosenProject != null)
      await _doVisitsStorageDataAdding(vBloc, pState);
  }

  Future<void> _doVisitsStorageDataAdding(VisitsBloc vBloc, ProjectsState pState)async{
    final int chosenProjectId = pState.chosenProject.id;
    final List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getPreloadedVisitsByProjectId(chosenProjectId);
    final SetVisits svEvent = SetVisits(visits: preloadedVisits);
    vBloc.add(svEvent);
  }

  @override
  Future<void> addStorageDataToFormulariosBloc(FormulariosBloc fBloc)async{
    final VisitsState vState = super.blocs[BlocName.Visits].state;
    if(vState.chosenVisit != null)
      await _doFormsStorageDataAdding(fBloc, vState);
  }
  
  Future<void> _doFormsStorageDataAdding(FormulariosBloc fBloc, VisitsState vState)async{
    final int chosenVisitId = vState.chosenVisit.id;
    final List<Formulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisitId);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    fBloc.add(sfEvent);
  }
}