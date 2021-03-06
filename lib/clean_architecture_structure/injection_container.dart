//sl: service locator
import 'package:gap/clean_architecture_structure/core/data/repositories/formularios/fake_impl/formularios_repository_fake.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/preloaded/send_preloaded_data.dart';
import 'package:gap/clean_architecture_structure/core/platform/locator.dart';
import 'package:gap/clean_architecture_structure/core/platform/native_services_permission.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/preloaded_data/preloaded_data_bloc.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/get_formularios.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/choose_formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/presentation/bloc/formularios_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/domain/helpers/usecase_permissions_manager.dart';
import 'core/network/network_info.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'core/domain/use_cases/user/logout.dart';
import 'core/data/repositories/index_repository.dart';
import 'core/data/repositories/preloaded_repository.dart';
import 'core/domain/repositories/index_repository.dart';
import 'core/domain/repositories/preloaded_repository.dart';
import 'core/domain/repositories/user_repository.dart';
import 'core/domain/repositories/visits_repository.dart';
import 'core/data/data_sources/user/user_local_data_source.dart';
import 'core/data/data_sources/user/user_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/data/data_sources/visits/visits_local_data_source.dart';
import 'core/data/data_sources/visits/visits_remote_data_source.dart';
import 'core/data/data_sources/navigation/navigation_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/login.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/pop.dart';
import 'package:gap/clean_architecture_structure/core/presentation/utils/input_validator.dart';
import 'package:gap/clean_architecture_structure/core/presentation/notifiers/keyboard_notifier.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/save_formulario.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/notifier/visits_change_notifier.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/update_preparaciones.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_chosen_project.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/set_chosen_project.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/get_chosen_visit.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/get_visits.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/set_chosen_visit.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/data_sources/muestras_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/repository/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/central_system/central_system_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/commented_images_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/formularios/formularios_repository.dart';
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
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/utils/string_to_double_converter.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_projects.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/commented_images/commented_images_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/index/index_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'core/data/data_sources/projects/projects_local_data_source.dart';
import 'core/data/data_sources/projects/projects_remote_data_source.dart';
import 'features/formularios/domain/usecases/end_chosen_formulario.dart';
import 'features/formularios/domain/usecases/init_formulario.dart';
import 'features/formularios/domain/usecases/update_campos.dart';
import 'features/muestras/domain/use_cases/remove_muestra.dart';
import 'features/visits/presentation/bloc/visits_bloc.dart';
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
  sl.registerLazySingleton<UserRemoteDataSource>(()=>UserRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(()=>UserLocalDataSourceImpl(storageConnector: sl()));
  
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
  /*
  sl.registerLazySingleton<FormulariosRepository>(()=>FormulariosRepositoryImpl(
    networkInfo: sl(), 
    remoteDataSource: sl(), 
    localDataSource: sl(), 
    preloadedDataSource: sl(), 
    userLocalDataSource: sl(), 
    visitsLocalDataSource: sl(), 
    projectsLocalDataSource: sl()s
  ));
  */
  sl.registerLazySingleton<FormulariosRepository>(()=>FormulariosRepositoryFake());

  sl.registerLazySingleton<PreloadedRepository>(()=>PreloadedRepositoryImpl(
    networkInfo: sl(),    
    userLocalDataSource: sl(), 
    localDataSource: sl(),
    formulariosRemoteDataSource: sl(),
    formulariosLocalDataSource: sl(),
    muestrasRemoteDataSource: sl()  
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
  
  sl.registerLazySingleton(() => SendPreloadedData(repository: sl()));
  sl.registerLazySingleton<PreloadedDataBloc>(()=>PreloadedDataBloc(
    sendPreloadedData: sl(),
    goTo: sl()
  ));
  //TODO: Quitar al confirmar funcionamiento correcto de MuestrasRepositoryImpl
  //sl.registerLazySingleton<MuestrasRepository>(()=>MuestrasRepositoryFake());
  ///*
  sl.registerLazySingleton<MuestrasRepository>(()=>MuestrasRepositoryImpl(
    networkInfo: sl(),
    remoteDataSource: sl(),
    userLocalDataSource: sl(), 
    projectsLocalDataSource: sl(),
    visitsLocalDataSource: sl(),
    formulariosRemoteDataSource: sl(), 
    preloadedLocalDataSource: sl()
  ));
  //*/

  //useCases
  sl.registerLazySingleton<UseCaseErrorHandler>(()=>UseCaseErrorHandlerImpl(
    centralSystemRepository: sl(), 
    userRepository: sl()
  ));
  sl.registerLazySingleton(()=>GoTo(navigator: sl(), navRepository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>Pop(navigator: sl(), navRepository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>GoReplacingAllTo(navigator: sl(), navRepository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>GoToLastRoute(navigator: sl(), navRepository: sl()));
  sl.registerLazySingleton(()=>Login(userRepository: sl(), centralSystemRepository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>Logout(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>GetMuestras(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>SetMuestra(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>UpdatePreparaciones(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>RemoveMuestra(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>SaveFormulario(repository: sl(), errorHandler: sl()));

  //blocs
  sl.registerFactory(() => UserBloc(
    login: sl(), 
    logout: sl(), 
    inputValidator: sl(), 
    navigationUseCase: sl()
  ));
  
  sl.registerFactory(()=>MuestrasBloc(
    getMuestras: sl(), 
    setMuestra: sl(),
    pesosConverter: sl(),
    updatePreparaciones: sl(),
    removeMuestra: sl(),
    saveFormulario: sl()
  ));
  sl.registerFactory(()=>NavigationBloc(
    goTo: sl(), 
    goReplacingAllTo: sl(), 
    pop: sl()
  ));

  //change notifiers
  sl.registerFactory(() => KeyboardNotifier());


  // ******************************* Features ***********************************

  // Projects
  sl.registerLazySingleton<ProjectsRemoteDataSource>(()=>ProjectsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<ProjectsLocalDataSource>(()=>ProjectsLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<ProjectsRepository>(()=>ProjectsRepositoryImpl(
    networkInfo: sl(),
    localDataSource: sl(), 
    remoteDataSource: sl(), 
    preloadedLocalDataSource: sl(), 
    userLocalDataSource: sl()
  ));
  sl.registerLazySingleton(()=>GetProjects(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>GetChosenProject(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>SetChosenProject(repository: sl(), errorHandler: sl()));
  sl.registerFactory(()=>ProjectsBloc(
    getProjects: sl(),
    getChosenProject: sl(),
    setChosenProject: sl()
  ));

  // Visits
  sl.registerLazySingleton<VisitsRemoteDataSource>(()=>VisitsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<VisitsLocalDataSource>(()=>VisitsLocalDataSourceImpl(storageConnector: sl()));
  sl.registerLazySingleton<VisitsRepository>(()=>VisitsRepositoryImpl(
    networkInfo: sl(), 
    remoteDataSource: sl(), 
    localDataSource: sl(), 
    preloadedDataSource: sl(), 
    userLocalDataSource: sl(), 
    projectsLocalDataSource: sl(), 
    formulariosRemoteDataSource: sl(),
    muestrasRemoteDataSource: sl()
  ));
  sl.registerLazySingleton(()=>GetVisits(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>SetChosenVisit(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>GetChosenVisit(repository: sl(), errorHandler: sl()));
  sl.registerFactory(()=>VisitsBloc(
    getVisits: sl(), 
    setChosenVisit: sl(), 
    getChosenVisit: sl()
  ));
  sl.registerFactory(()=>VisitsChangeNotifier());

  //Formularios
  sl.registerLazySingleton(()=>GetFormularios(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(()=>ChooseFormulario(
    repository: sl(), 
    errorHandler: sl(), 
    permissions: sl(), 
    locator: sl())
  );
  sl.registerLazySingleton(() => InitChosenFormulario(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(() => UpdateCampos(repository: sl(), errorHandler: sl()));
  sl.registerLazySingleton(() => EndChosenFormulario(
    repository: sl(), 
    errorHandler: sl(), 
    permissions: sl(), 
    locator: sl()
  ));
  sl.registerFactory(()=>FormulariosBloc(
    getFormularios: sl(), 
    setChosenFormulario: sl(),
    initChosenFormulario: sl(),
    updateCampos: sl(),
    endChosenFormulario: sl()
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
  sl.registerLazySingleton<UseCasePermissionsManager>(()=>
    UseCasePermissionsManagerImpl(permissions: sl())
  );
  sl.registerLazySingleton<CustomLocator>(()=>
    CustomLocatorImpl()  
  );

  //**********External
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FlutterSecureStorage());
  sl.registerLazySingleton<NativeServicesPermissions>(() => NativeServicesPermissionsImpl());
}