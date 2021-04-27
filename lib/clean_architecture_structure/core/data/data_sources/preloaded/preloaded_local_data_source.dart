import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class PreloadedLocalDataSource{
  Future<void> setPreloadedFamily(int projectId, int visitId, List<FormularioModel> formularios);
  Future<List<int>> getPreloadedProjectsIds(); 
  Future<List<int>> getPreloadedVisitsIds(int projectId);
  Future<List<FormularioModel>> getPreloadedFormularios(int projectId, int visitId);
  Future<void> updatePreloadedFormulario(int projectId, int visitId, FormularioModel formulario);
  Future<void> removePreloadedFormulario(int formularioId);
}

class PreloadedLocalDataSourceImpl implements PreloadedLocalDataSource{
  static const preloadedDataStorageKey = 'preloaded_data';
  final StorageConnector storageConnector;

  PreloadedLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setPreloadedFamily(int projectId, int visitId, List<FormularioModel> formularios)async{
    Map<String, dynamic> preloadedData = (await storageConnector.getMap(preloadedDataStorageKey) )??{};
    Map<String, dynamic> preloadedProject = preloadedData['$projectId']??{};
    List<Map<String, dynamic>> previousFormularios = (preloadedProject['$visitId']??[]).cast<Map<String, dynamic>>();
    preloadedProject['$visitId'] = _updatePreloadedFormularios(previousFormularios, formularios);
    preloadedProject = _getprojectDataWithoutEmptyVisits(preloadedProject);
    preloadedData['$projectId'] = preloadedProject;
    await storageConnector.setMap(preloadedData, preloadedDataStorageKey);
  }

  List<Map<String, dynamic>> _updatePreloadedFormularios(List<Map<String, dynamic>> previousFormularios, List<FormularioModel> newFormularios){
    if(previousFormularios.length == 0)
      previousFormularios = formulariosToJson(newFormularios);
    newFormularios.forEach((nF){
      if(nF.completo)
        previousFormularios.removeWhere((pF) => pF['formulario_pivot_id'] == nF.id);
    });
    return previousFormularios;
  }

  Map<String, dynamic> _getprojectDataWithoutEmptyVisits(Map<String, dynamic> projectData){
    Map<String, dynamic> newProjectData = {};
    projectData.forEach((key, value) {
      if((value as List).isNotEmpty)
        newProjectData[key] = value;
    });
    return newProjectData;
  }

  @override
  Future<List<int>> getPreloadedProjectsIds()async{
    Map<String, dynamic> preloadedData = await storageConnector.getMap(preloadedDataStorageKey);
    preloadedData = _getPreloadedDataWithEmptyProjects(preloadedData);
    List<int> projectsIds = [];
    preloadedData.forEach((key, _) {
      projectsIds.add(int.parse(key));
    });
    return projectsIds;
  }

  @protected
  Map<String, dynamic> _getPreloadedDataWithEmptyProjects(Map<String, dynamic> preloadedData){
    Map<String, dynamic> cleanedPreloadedData = {};
    preloadedData.forEach((key, value) {
      if((value as Map).isNotEmpty)
        cleanedPreloadedData[key] = value;
    });
    return cleanedPreloadedData;
  }

  @override
  Future<List<int>> getPreloadedVisitsIds(int projectId)async{
    final Map<String, dynamic> preloadedData = await storageConnector.getMap(preloadedDataStorageKey);
    Map<String, dynamic> projectData = preloadedData['$projectId'];
    projectData = _getProjectDataWithEmptyVisitsRemoved(projectData);
    List<int> visitsIds = [];
    if(projectData != null){
      projectData.forEach((key, _) {
        visitsIds.add(int.parse(key));
      });
    }
    return visitsIds;
  }

  Map<String, dynamic> _getProjectDataWithEmptyVisitsRemoved(Map<String, dynamic> projectData){
    Map<String, dynamic> cleanedProjectData = {};
    projectData.forEach((key, value) {
      if(value!=null && (value as List).isNotEmpty)
        cleanedProjectData[key] = value;
    });
    return cleanedProjectData;
  }

  @override
  Future<List<FormularioModel>> getPreloadedFormularios(int projectId, int visitId)async{
    final Map<String, dynamic> preloadedData = await storageConnector.getMap(preloadedDataStorageKey);
    final Map<String, dynamic> projectData = preloadedData['$projectId']??{};
    final List<Map<String, dynamic>> visitData = (projectData['$visitId']??[] ).cast<Map<String, dynamic>>();
    List<FormularioModel> formularios = formulariosFromJson(visitData);
    return formularios;
  }

  @override
  Future<void> updatePreloadedFormulario(int projectId, int visitId, FormularioModel formulario)async{
    Map<String, dynamic> preloadedData = (await storageConnector.getMap(preloadedDataStorageKey) )??{};
    Map<String, dynamic> projectData = preloadedData['$projectId'];
    if(projectData != null){
      List<Map<String, dynamic>> visitData = projectData['$visitId'].cast<Map<String, dynamic>>();
      if(visitData != null)
        _updateFormInVisitForms(visitData, formulario);
    }
    projectData = _getprojectDataWithoutEmptyVisits(projectData);
    preloadedData['$projectId'] = projectData;
    await storageConnector.setMap(preloadedData, preloadedDataStorageKey);
  }

  void _updateFormInVisitForms(List<Map<String, dynamic>> visitForms, FormularioModel formulario){
    int formularioIndex = visitForms.indexWhere((f) => f['formulario_pivot_id'] == formulario.id);
    visitForms[formularioIndex] = formulario.toJson();
  }

  @override
  Future<void> removePreloadedFormulario(int formularioId)async{
    Map<String, dynamic> preloadedData = (await storageConnector.getMap(preloadedDataStorageKey) )??{};
    preloadedData = preloadedData.map((projectId, projectData){
      return MapEntry(
        projectId,
        (projectData as Map).map((visitId, visitData){
          visitData = (visitData as List).where((f) => f['formulario_pivot_id'] != formularioId).toList();
          return MapEntry(visitId, visitData);
        })
      );
    });
    await storageConnector.setMap(preloadedData, preloadedDataStorageKey);
  }
}