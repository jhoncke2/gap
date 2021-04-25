import 'package:dartz/dartz.dart';
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
    bool sentAnyData = false;
    for(int projectId in projectsIds){
      final List<int> visitsIds = await localDataSource.getPreloadedVisitsIds(projectId);
      for(int visitId in visitsIds){
        final List<FormularioModel> formularios = await localDataSource.getPreloadedFormularios(projectId, visitId);
        for(FormularioModel formulario in formularios){
          if(formulario.initialPosition != null){
            await formulariosRemoteDataSource.setInitialPosition(formulario.initialPosition, formulario.id, accessToken);
            sentAnyData = true;
          }
          if(_canSendCampos(formulario)){
            await formulariosRemoteDataSource.setCampos(formulario, visitId, accessToken);
            sentAnyData = true;
          }
          if(formulario.finalPosition != null){
            await formulariosRemoteDataSource.setFinalPosition(formulario.finalPosition, formulario.id, accessToken);
            sentAnyData = true;
          }    
          if(![null, []].contains(formulario.firmers)){
            for(FirmerModel firmer in formulario.firmers)
              await formulariosRemoteDataSource.setFirmer(firmer, formulario.id, visitId, accessToken);
            //Por fuera del ciclo: si no pudo enviar todas las firmas, mejor tomarlo como que no se pudo enviar data.
            sentAnyData = true;
          }
        }
      }
    }
    return sentAnyData;
  }

  bool _canSendCampos(FormularioModel formulario){
    return formulario.completo && ![null, []].contains(formulario.campos);
  }
}