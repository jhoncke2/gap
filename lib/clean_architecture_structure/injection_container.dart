//sl: service locator
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_chosen_project.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/set_chosen_project.dart';
import 'package:get_it/get_it.dart';
import 'core/network/network_info.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/data_sources/muestras_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/repository/muestras_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/central_system/central_system_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/commented_images_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/features/projects/data/repository/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/commented_images_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_replacing_all_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to_last_route.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/pop.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/login.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/clean_architecture_structure/core/presentation/utils/input_validator.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/utils/string_to_double_converter.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_projects.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/bloc/projects_bloc.dart';
import 'core/data/data_sources/navigation/navigation_local_data_source.dart';
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
import 'core/domain/use_cases/user/logout.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/commented_images/commented_images_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/index/index_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'core/data/data_sources/projects/projects_local_data_source.dart';
import 'core/data/data_sources/projects/projects_remote_data_source.dart';
import 'core/presentation/blocs/user/user_bloc.dart';

final sl = GetIt.instance;

void init()async{
  //*********Core
  //*****data
  //data sources
  sl.registerLazySingleton<CentralSystemLocalDataSource>(() => CentralSystemLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<CommentedImagesRemoteDataSource>(()=>CommentedImagesRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<FormulariosRemoteDataSource>(()=>FormulariosRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<FormulariosLocalDataSource>(()=>FormulariosLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<IndexLocalDataSource>(()=>IndexLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<PreloadedLocalDataSource>(()=>PreloadedLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<ProjectsRemoteDataSource>(()=>ProjectsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<ProjectsLocalDataSource>(()=>ProjectsLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(()=>UserRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(()=>UserLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<VisitsRemoteDataSource>(()=>VisitsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<VisitsLocalDataSource>(()=>VisitsLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<NavigationLocalDataSource>(()=> NavigationLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<MuestrasRemoteDataSource>(()=> MuestrasRemoteDataSourceImpl(client: sl()));
  
  //repositories
  sl.registerLazySingleton<CentralSystemRepository>(()=>CentralSystemRepositoryImpl(
    localDataSource: sl()
  ));
  sl.registerLazySingleton<CommentedImagesRepository>(()=>CommentedImagesRepositoryImpl(
    networkInfo: sl(), 
    remoteDataSource: sl(), 
    userLocalDataSource: sl(), 
    projectsLocalDataSource: sl(), 
    visitsLocalDataSource: sl()
  ));
  sl.registerLazySingleton<ProjectsRepository>(()=>ProjectsRepositoryImpl(
    networkInfo: sl(), 
    localDataSource: sl(), 
    remoteDataSource: sl(), 
    preloadedLocalDataSource: sl(), 
    userLocalDataSource: sl()
  ));
  sl.registerLazySingleton<VisitsRepository>(()=>VisitsRepositoryImpl(
    networkInfo: sl(), 
    remoteDataSource: sl(), 
    localDataSource: sl(), 
    preloadedDataSource: sl(), 
    userLocalDataSource: sl(), 
    projectsLocalDataSource: sl(), 
    formulariosRemoteDataSource: sl()
  ));
  sl.registerLazySingleton<FormulariosRepository>(()=>FormulariosRepositoryImpl(
    networkInfo: sl(), 
    remoteDataSource: sl(), 
    localDataSource: sl(), 
    preloadedDataSource: sl(), 
    userLocalDataSource: sl(), 
    visitsLocalDataSource: sl(), 
    projectsLocalDataSource: sl()
  ));
  sl.registerLazySingleton<PreloadedRepository>(()=>PreloadedRepositoryImpl(
    networkInfo: sl(),    
    userLocalDataSource: sl(), 
    localDataSource: sl(),
    formulariosRemoteDataSource: sl(),
    formulariosLocalDataSource: sl()    
  ));
  sl.registerLazySingleton<IndexRepository>(()=>IndexRepositoryImpl(
    localDataSource: sl()
  ));
  sl.registerLazySingleton<UserRepository>(()=>UserRepositoryImpl(
    networkInfo: sl(),
    remoteDataSource: sl(),
    localDataSource: sl(), 
    centralSystemLocalDataSource: sl(),    
  ));
  sl.registerLazySingleton<NavigationRepository>(()=>NavigationRepositoryImpl(
    localDataSource: sl()
  ));
  //TODO: Quitar al confirmar funcionamiento correcto de MuestrasRepositoryImpl
  //sl.registerLazySingleton<MuestrasRepository>(()=>MuestrasRepositoryFake());
  sl.registerLazySingleton<MuestrasRepository>(()=>MuestrasRepositoryImpl(
    networkInfo: sl(),
    remoteDataSource: sl(),
    userLocalDataSource: sl(), 
    projectsLocalDataSource: sl(),
    visitsLocalDataSource: sl()
  ));

  //useCases
  sl.registerLazySingleton(()=>GoTo(navigator: sl(), navRepository: sl()));
  sl.registerLazySingleton(()=>Pop(navigator: sl(), navRepository: sl()));
  sl.registerLazySingleton(()=>GoReplacingAllTo(navigator: sl(), navRepository: sl()));
  sl.registerLazySingleton(()=>GoToLastRoute(navigator: sl(), navRepository: sl()));
  sl.registerLazySingleton(()=>Login(userRepository: sl(), centralSystemRepository: sl()));
  sl.registerLazySingleton(()=>Logout(repository: sl()));
  sl.registerLazySingleton(()=>GetProjects(repository: sl()));
  sl.registerLazySingleton(()=>GetChosenProject(repository: sl()));
  sl.registerLazySingleton(()=>SetChosenProject(repository: sl()));
  sl.registerLazySingleton(()=>GetMuestras(repository: sl()));
  sl.registerLazySingleton(()=>SetMuestra(repository: sl()));
  //blocs
  sl.registerFactory(() => UserBloc(
    login: sl(), 
    logout: sl(), 
    inputValidator: sl(), 
    navigationUseCase: sl()
  ));
  sl.registerFactory(()=>ProjectsBloc(
    getProjects: sl(),
    getChosenProject: sl(),
    setChosenProject: sl()
  ));
  sl.registerFactory(()=>MuestrasBloc(
    getMuestras: sl(), 
    setMuestra: sl(),
    pesosConverter: sl()
  ));
  sl.registerFactory(()=>NavigationBloc(
    goTo: sl(), 
    goReplacingAllTo: sl(), 
    pop: sl()
  ));

  //***** util components
  sl.registerLazySingleton(()=>InputValidator());
  sl.registerLazySingleton(()=>StringToDoubleConverter());

  //***********External encapsulation
  sl.registerLazySingleton<NetworkInfo>(() => 
    NetworkInfoImpl(connectivity: sl())
  );
  sl.registerLazySingleton<StorageConnector>(() => 
    StorageConnectorImpl(fss: sl())
  );
  sl.registerLazySingleton<CustomNavigator>(()=>
    CustomNavigatorImpl()
  );


  //**********External
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FlutterSecureStorage());
}