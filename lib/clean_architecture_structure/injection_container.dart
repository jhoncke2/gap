//sl: service locator
import 'package:gap/clean_architecture_structure/core/data/data_sources/central_system/central_system_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/commented_images_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/commented_images_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'core/data/data_sources/user/user_local_data_source.dart';
import 'core/data/data_sources/user/user_remote_data_source.dart';
import 'core/data/data_sources/visits/visits_local_data_source.dart';
import 'core/data/data_sources/visits/visits_remote_data_source.dart';
import 'core/data/repositories/index_repository.dart';
import 'core/data/repositories/preloaded_repository.dart';
import 'core/domain/repositories/index_repository.dart';
import 'core/domain/repositories/preloaded_repository.dart';
import 'core/domain/repositories/user_repository.dart';
import 'core/domain/repositories/visits_repository.dart';
import 'core/network/network_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/commented_images/commented_images_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/index/index_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'core/data/data_sources/projects/projects_local_data_source.dart';
import 'core/data/data_sources/projects/projects_remote_data_source.dart';



//TODO: Borrar cuando haya arreglado la estructura completa de la app.
class GetItContainer{
  static final sl = GetIt.instance;
}

void init()async{
  //*********Core
  //*****data
  //data sources
  GetItContainer.sl.registerLazySingleton<CommentedImagesRemoteDataSource>(()=>CommentedImagesRemoteDataSourceImpl(client: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<FormulariosRemoteDataSource>(()=>FormulariosRemoteDataSourceImpl(client: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<FormulariosLocalDataSource>(()=>FormulariosLocalDataSourceImpl(storageConnector: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<IndexLocalDataSource>(()=>IndexLocalDataSourceImpl(storageConnector: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<PreloadedLocalDataSource>(()=>PreloadedLocalDataSourceImpl(storageConnector: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<ProjectsRemoteDataSource>(()=>ProjectsRemoteDataSourceImpl(client: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<ProjectsLocalDataSource>(()=>ProjectsLocalDataSourceImpl(storageConnector: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<UserRemoteDataSource>(()=>UserRemoteDataSourceImpl(client: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<UserLocalDataSource>(()=>UserLocalDataSourceImpl(storageConnector: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<VisitsRemoteDataSource>(()=>VisitsRemoteDataSourceImpl(client: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<VisitsLocalDataSource>(()=>VisitsLocalDataSourceImpl(storageConnector: GetItContainer.sl()));
  GetItContainer.sl.registerLazySingleton<CentralSystemLocalDataSource>(() => CentralSystemLocalDataSourceImpl(storageConnector: GetItContainer.sl()));
  //repositories
  GetItContainer.sl.registerLazySingleton<CommentedImagesRepository>(()=>CommentedImagesRepositoryImpl(
    networkInfo: GetItContainer.sl(), 
    remoteDataSource: GetItContainer.sl(), 
    userLocalDataSource: GetItContainer.sl(), 
    projectsLocalDataSource: GetItContainer.sl(), 
    visitsLocalDataSource: GetItContainer.sl()
  ));
  GetItContainer.sl.registerLazySingleton<ProjectsRepository>(()=>ProjectsRepositoryImpl(
    networkInfo: GetItContainer.sl(), 
    localDataSource: GetItContainer.sl(), 
    remoteDataSource: GetItContainer.sl(), 
    preloadedLocalDataSource: GetItContainer.sl(), 
    userLocalDataSource: GetItContainer.sl()
  ));
  GetItContainer.sl.registerLazySingleton<VisitsRepository>(()=>VisitsRepositoryImpl(
    networkInfo: GetItContainer.sl(), 
    remoteDataSource: GetItContainer.sl(), 
    localDataSource: GetItContainer.sl(), 
    preloadedDataSource: GetItContainer.sl(), 
    userLocalDataSource: GetItContainer.sl(), 
    projectsLocalDataSource: GetItContainer.sl(), 
    formulariosRemoteDataSource: GetItContainer.sl()
  ));
  GetItContainer.sl.registerLazySingleton<FormulariosRepository>(()=>FormulariosRepositoryImpl(
    networkInfo: GetItContainer.sl(), 
    remoteDataSource: GetItContainer.sl(), 
    localDataSource: GetItContainer.sl(), 
    preloadedDataSource: GetItContainer.sl(), 
    userLocalDataSource: GetItContainer.sl(), 
    visitsLocalDataSource: GetItContainer.sl(), 
    projectsLocalDataSource: GetItContainer.sl()
  ));
  GetItContainer.sl.registerLazySingleton<PreloadedRepository>(()=>PreloadedRepositoryImpl(
    networkInfo: GetItContainer.sl(),    
    userLocalDataSource: GetItContainer.sl(), 
    localDataSource: GetItContainer.sl(),
    formulariosRemoteDataSource: GetItContainer.sl(),
    formulariosLocalDataSource: GetItContainer.sl()    
  ));
  GetItContainer.sl.registerLazySingleton<IndexRepository>(()=>IndexRepositoryImpl(
    localDataSource: GetItContainer.sl()
  ));
  GetItContainer.sl.registerLazySingleton<UserRepository>(()=>UserRepositoryImpl(
    networkInfo: GetItContainer.sl(),
    remoteDataSource: GetItContainer.sl(),
    localDataSource: GetItContainer.sl(), 
    centralSystemLocalDataSource: GetItContainer.sl(),    
  ));



  //***********External encapsulation
  GetItContainer.sl.registerLazySingleton<NetworkInfo>(() => 
    NetworkInfoImpl(connectivity: GetItContainer.sl())
  );
  GetItContainer.sl.registerLazySingleton<StorageConnector>(() => 
    StorageConnectorImpl(fss: GetItContainer.sl())
  );


  //**********External
  GetItContainer.sl.registerLazySingleton(() => Connectivity());
  GetItContainer.sl.registerLazySingleton(() => http.Client());
  GetItContainer.sl.registerLazySingleton(() => FlutterSecureStorage());
}