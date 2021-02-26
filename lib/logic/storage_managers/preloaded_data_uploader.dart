import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';

class PreloadedDataUploader{
  static Future<void> setPreloadedVisitData(List<Formulario> forms, BuildContext context)async{
    final Project chosenProject = BlocProvider.of<ProjectsBloc>(context).state.chosenProjectOld;
    final Visit chosenVisit = BlocProvider.of<VisitsBloc>(context).state.chosenVisit;
    await ProjectsStorageManager.setProjectWithPreloadedVisits(chosenProject);
    await PreloadedVisitsStorageManager.setVisit(chosenVisit, chosenProject.id);
    forms.forEach((Formulario form)async{
      await PreloadedFormsStorageManager.setPreloadedForm(form, chosenVisit.id);
    });
  }
}