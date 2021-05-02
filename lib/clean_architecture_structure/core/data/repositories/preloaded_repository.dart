import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/firmer.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/preloaded_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';

class PreloadedRepositoryImpl implements PreloadedRepository{
  final NetworkInfo networkInfo;
  final UserLocalDataSource userLocalDataSource;
  final PreloadedLocalDataSource localDataSource;
  final FormulariosRemoteDataSource formulariosRemoteDataSource;
  final FormulariosLocalDataSource formulariosLocalDataSource;
  bool _sentAnyData;

  PreloadedRepositoryImpl({
    @required this.networkInfo,
    @required this.userLocalDataSource,
    @required this.localDataSource, 
    @required this.formulariosRemoteDataSource, 
    @required this.formulariosLocalDataSource
  });

  @override
  Future<Either<Failure, bool>> sendPreloadedData()async{
    try{
      return Right( await _trySendPreloadedData() );
    }on ServerException{
      return Left(ServerFailure());
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  Future<bool> _trySendPreloadedData()async{
    if( await networkInfo.isConnected() ){
      final String accessToken = await userLocalDataSource.getAccessToken();
      final List<int> projectsIds = await localDataSource.getPreloadedProjectsIds();
      return _sentDataInProjects(projectsIds, accessToken);
    }
    return false;
  }

  Future<bool> _sentDataInProjects(List<int> projectsIds, String accessToken)async{
    _sentAnyData = false;
    for(int projectId in projectsIds){
      final List<int> visitsIds = await localDataSource.getPreloadedVisitsIds(projectId);
      for(int visitId in visitsIds){
        final List<FormularioModel> formularios = await localDataSource.getPreloadedFormularios(projectId, visitId);
        for(FormularioModel formulario in formularios){
          await _sendFormularioData(formulario, projectId, visitId, accessToken);
        }
      }
    }
    return _sentAnyData;
  }

  Future<void> _sendFormularioData(FormularioModel formulario, int projectId, int visitId, String accessToken)async{
    //print('******************');
    //print('${formulario.toJson()}');
    if(formulario.initialPosition != null){
      await formulariosRemoteDataSource.setInitialPosition(formulario.initialPosition, formulario.id, accessToken);
      formulario.initialPosition = null;
      await localDataSource.updatePreloadedFormulario(projectId, visitId, formulario);
      _sentAnyData = true;
    }
    if(_canSendCampos(formulario)){
      await formulariosRemoteDataSource.setCampos(formulario, visitId, accessToken);
      formulario = formulario.copyWith(campos: []);
      await localDataSource.updatePreloadedFormulario(projectId, visitId, formulario);
      _sentAnyData = true;
    }
    if(formulario.finalPosition != null){
      await formulariosRemoteDataSource.setFinalPosition(formulario.finalPosition, formulario.id, accessToken);
      formulario.finalPosition = null;
      await localDataSource.updatePreloadedFormulario(projectId, visitId, formulario);
      _sentAnyData = true;
    }
    if(_hasFirmers(formulario)){
      for(int i = 0; i < formulario.firmers.length; i++){
        await formulariosRemoteDataSource.setFirmer(formulario.firmers[i], formulario.id, visitId, accessToken);
        FormularioModel formularioWithoutFirmer = formulario.copyWith(
          firmers: List.from(formulario.firmers)..removeRange(0, i+1)
        );
        await localDataSource.updatePreloadedFormulario(projectId, visitId, formularioWithoutFirmer);
      }
      //Por fuera del ciclo: si no pudo enviar todas las firmas, mejor tomarlo como que no se pudo enviar data.
      _sentAnyData = true;
    }
    if(_formularioSentAllItsData(formulario))
      await localDataSource.removePreloadedFormulario(formulario.id);
  }

  bool _canSendCampos(FormularioModel formulario){
    return formulario.completo && formulario.campos != null && formulario.campos.isNotEmpty;
  }

  bool _hasFirmers(FormularioModel formulario){
    return ![null, []].contains(formulario.firmers);
  }

  bool _formularioSentAllItsData(Formulario formulario){
    return formulario.initialPosition == null 
      && formulario.campos.isEmpty
      && formulario.finalPosition == null
      && formulario.firmers.isEmpty;
  }
}