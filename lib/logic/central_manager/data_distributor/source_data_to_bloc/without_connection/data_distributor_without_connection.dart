import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/data_distributor.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

class SourceDataToBlocWithoutConnection extends DataDistributor{
  
  @override
  Future<void> updateProjects()async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    final List<OldProject> projectsWithPreloadedVisits = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final SetOldProjects spEvent = SetOldProjects(oldProjects: projectsWithPreloadedVisits);
    pBloc.add(spEvent);
    ProjectsStorageManager.setProjects(projectsWithPreloadedVisits);
  }

  @override
  Future<void> updateVisits()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final OldProject chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    final List<OldVisit> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(chosenProject.id);
    final SetVisits svEvent = SetVisits(visits: preloadedVisits);
    vBloc.add(svEvent);
  }

  @override
  Future updateChosenVisit(OldVisit visit)async{
    await addChosenVisitToBloc(visit);
    await _updateFormularios(visit);
    await _addVisitToStorage(visit);
  }

  Future _updateFormularios(OldVisit chosenVisit)async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    final List<OldFormulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    fBloc.add(sfEvent);
  }

  Future _addVisitToStorage(OldVisit visit)async{
    await VisitsStorageManager.setChosenVisit(visit);
  }

  @override
  Future<void> updateFormularios()async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    final OldVisit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<OldFormulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    fBloc.add(sfEvent);
  }
}