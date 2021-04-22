import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/firmer.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded_data/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';

class FormulariosRepositoryImpl implements FormulariosRepository{
  final NetworkInfo networkInfo;
  final FormulariosRemoteDataSource remoteDataSource;
  final FormulariosLocalDataSource localDataSource;
  final PreloadedLocalDataSource preloadedDataSource;
  final UserLocalDataSource userLocalDataSource;

  FormulariosRepositoryImpl({
    @required this.networkInfo, 
    @required this.remoteDataSource, 
    @required this.localDataSource, 
    @required this.preloadedDataSource,
    @required this.userLocalDataSource
  });

  @override
  Future<Either<Failure, List<Formulario>>> getFormularios()async{
    await networkInfo.isConnected();
    final String accessToken = await userLocalDataSource.getAccessToken();
    await remoteDataSource.getFormularios(accessToken);
  }

  @override
  Future<Either<Failure, void>> setFinalPosition(Position position) {
    // TODO: implement setFinalPosition
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setFirmer(Firmer firmer) {
    // TODO: implement setFirmer
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setFormulario(Formulario formulario) {
    // TODO: implement setFormulario
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setInitialPosition(Position position) {
    // TODO: implement setInitialPosition
    throw UnimplementedError();
  }
}