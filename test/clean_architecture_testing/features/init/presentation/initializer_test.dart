import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_replacing_all_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/clean_architecture_structure/core/platform/native_services_permission.dart';
import 'package:gap/clean_architecture_structure/features/init/domain/use_cases/get_app_already_runned.dart';
import 'package:gap/clean_architecture_structure/features/init/presentation/helpers/initializer.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockCustomNavigator extends Mock implements CustomNavigator{}
class MockNativeServicesPermissions extends Mock implements NativeServicesPermissions{}
class MockGetAppAlreadyRunned extends Mock implements GetAppAlreadyRunned{}
class MockGoReplacingAllTo extends Mock implements GoReplacingAllTo{}
class MockNavigationRepository extends Mock implements NavigationRepository{}

Initializer initializer;
MockCustomNavigator navigator;
MockNativeServicesPermissions permissions;
MockGetAppAlreadyRunned getAppAlreadyRunned;
MockGoReplacingAllTo goReplacingAllTo;
//TODO: Quitar cuando todo el proyecto esté con clean architecture
MockNavigationRepository navRepository;


void main(){
  setUp((){
    navRepository = MockNavigationRepository();
    goReplacingAllTo = MockGoReplacingAllTo();
    getAppAlreadyRunned = MockGetAppAlreadyRunned();
    permissions = MockNativeServicesPermissions();
    navigator = MockCustomNavigator();
    initializer = Initializer(
      customNavigator: navigator, 
      servicesPermissions: permissions,
      getAppAlreadyRunned: getAppAlreadyRunned,
      goReplacingAllTo: goReplacingAllTo,
      navRepository: navRepository
    );
  });

  group('init', (){

    test('''should do the expected when there is not storageGranted, 
    storageRequestStatus is ungranted, and api is never runned''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => false);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.UNGRANTED);
      when(getAppAlreadyRunned(any)).thenAnswer((_) async => Right(false));
      await initializer.init();
      verify(permissions.storageIsGranted);
      verify(permissions.storageRequestStatus);
      verifyNever(getAppAlreadyRunned(any));
      verifyNever(goReplacingAllTo(any));
      verifyNever(navigator.navigateReplacingTo(any));
    });

    test('''should do the expected when there is not storageGranted, 
    storageRequestStatus is granted, and api is never runned''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => false);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.GRANTED);
      when(getAppAlreadyRunned(any)).thenAnswer((_) async => Right(false));
      await initializer.init();
      verify(permissions.storageIsGranted);
      verify(permissions.storageRequestStatus);
      verify(getAppAlreadyRunned(NoParams()));
      verify(goReplacingAllTo(NavigationParams(navRoute: NavigationRoute.Login)));
      verify( navigator.navigateReplacingTo(NavigationRoute.Login) );
    });

    test('''should do the expected when there is not storageGranted, 
    storageRequestStatus is granted, and api is already runned''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => false);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.GRANTED);
      when(getAppAlreadyRunned(any)).thenAnswer((_) async => Right(true));
      when(navRepository.getCurrentRoute()).thenAnswer((_) async => Right( NavigationRoute.Projects ));
      await initializer.init();
      verify(permissions.storageIsGranted);
      verify(permissions.storageRequestStatus);
      verify(getAppAlreadyRunned(NoParams()));
      verify(navRepository.getCurrentRoute());
      verify(navigator.navigateReplacingTo(NavigationRoute.Projects));
    });

    test('''should do the expected when there is not storageGranted, 
    storageRequestStatus is granted, and api is already runned''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => false);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.GRANTED);
      when(getAppAlreadyRunned(any)).thenAnswer((_) async => Right(true));
      when(navRepository.getCurrentRoute()).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
      await initializer.init();
      verify(permissions.storageIsGranted);
      verify(permissions.storageRequestStatus);
      verify(getAppAlreadyRunned(NoParams()));
      verify(navRepository.getCurrentRoute());
      verify(navigator.navigateReplacingTo(NavigationRoute.Login));
    });

    test('''should do the expected when there is not storageGranted, 
    storageRequestStatus is ungranted, and api is never runned''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => true);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.GRANTED);
      when(getAppAlreadyRunned(any)).thenAnswer((_) async => Right(true));
      when(navRepository.getCurrentRoute()).thenAnswer((_) async => Right( NavigationRoute.Projects ));
      await initializer.init();
      verify(permissions.storageIsGranted);
      verifyNever(permissions.storageRequestStatus);
      verify(getAppAlreadyRunned(NoParams()));
      verify(navigator.navigateReplacingTo(NavigationRoute.Projects));
    });

    

    test('''should do the expected when there is storageGranted,
     and api is never runned''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => true);
      when(getAppAlreadyRunned(any)).thenAnswer((_) async => Right(false));
      when(navRepository.getCurrentRoute()).thenAnswer((_) async => Right( NavigationRoute.Projects ));
      await initializer.init();
      verify(permissions.storageIsGranted);
      verifyNever(permissions.storageRequestStatus);
      verify(getAppAlreadyRunned(NoParams()));
      verify(navigator.navigateReplacingTo(NavigationRoute.Login));
    });

    test('''should do the expected when there is  storageGranted,
     and api is already runned''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => true);
      when(getAppAlreadyRunned(any)).thenAnswer((_) async => Right(true));
      when(navRepository.getCurrentRoute()).thenAnswer((_) async => Right( NavigationRoute.Projects ));
      await initializer.init();
      verify(permissions.storageIsGranted);
      verifyNever(permissions.storageRequestStatus);
      verify(getAppAlreadyRunned(NoParams()));
      verify(navigator.navigateReplacingTo(NavigationRoute.Projects));
    });
  });
}