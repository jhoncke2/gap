import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/old_architecture/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';

class PreloadedDataUploader{
  static Future<void> setPreloadedVisitData(List<FormularioOld> forms, BuildContext context)async{
    final ProjectOld chosenProject = BlocProvider.of<ProjectsOldBloc>(context).state.chosenProjectOld;
    final VisitOld chosenVisit = BlocProvider.of<VisitsOldBloc>(context).state.chosenVisit;
    await ProjectsStorageManager.setProjectWithPreloadedVisits(chosenProject);
    await PreloadedVisitsStorageManager.setVisit(chosenVisit, chosenProject.id);
    forms.forEach((FormularioOld form)async{
      await PreloadedFormsStorageManager.setPreloadedForm(form, chosenVisit.id);
    });
  }
}