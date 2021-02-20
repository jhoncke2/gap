import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/source_data_to_bloc.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';

class SourceDataToBlocWithoutConnection extends SourceDataToBloc{
  @override
  Future<void> updateProjects()async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    final List<Project> projectsWithPreloadedVisits = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final SetProjects spEvent = SetProjects(projects: projectsWithPreloadedVisits);
    pBloc.add(spEvent);
  }

  @override
  Future<void> updateVisits()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    final List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(chosenProject.id);
    final SetVisits svEvent = SetVisits(visits: preloadedVisits);
    vBloc.add(svEvent);
  }

  @override
  Future<void> updateFormulariosBloc()async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<Formulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    fBloc.add(sfEvent);
  }
}