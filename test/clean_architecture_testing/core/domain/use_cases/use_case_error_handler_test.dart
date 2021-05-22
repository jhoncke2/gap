import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class MockClassX{
  Future<Either<Failure, int>> functionX(){
    return null;
  }
}
class MockClassXImpl extends Mock implements MockClassX{}

class MockCentralSystemRepository extends Mock implements CentralSystemRepository{}
class MockUserRepository extends Mock implements UserRepository{}

UseCaseErrorHandlerImpl errorHandler;
MockCentralSystemRepository centralSystemRepository;
MockUserRepository userRepository;
MockClassXImpl classX;

void main(){

  setUp((){
    centralSystemRepository = MockCentralSystemRepository();
    userRepository = MockUserRepository();
    errorHandler = UseCaseErrorHandlerImpl(
      centralSystemRepository: centralSystemRepository,
      userRepository: userRepository
    );
    classX = MockClassXImpl();
  });

  test('should call the param function', ()async{
    when(classX.functionX()).thenAnswer( (_) async => Right(1) );
    await errorHandler.executeFunctionOld(classX.functionX);
    verify(classX.functionX());
  });

  test('should return the functionX returned value when all goes good', ()async{
    when(classX.functionX()).thenAnswer( (_) async => Right(1) );
    final result = await errorHandler.executeFunctionOld(classX.functionX);
    expect(result, Right(1));
  });

  test('''should call the centralSystemRepository deleteAll and init methods 
  when there is a Left( StorageFailure(PLATFORM) )''', ()async{
    when(classX.functionX()).thenAnswer((realInvocation) async => Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    final result = await errorHandler.executeFunctionOld(classX.functionX);
    verify(classX.functionX()).called(2);
    verify(centralSystemRepository.removeAll());
    verify(centralSystemRepository.setAppRunnedAnyTime());
    expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
  });

  test('''should call the centralSystemRepository deleteAll and init methods 
  when there is a Left( StorageFailure(PLATFORM) )''', ()async{
    when(classX.functionX()).thenAnswer((realInvocation) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    final result = await errorHandler.executeFunctionOld(classX.functionX);
    verify(classX.functionX()).called(1);
    verifyNever(centralSystemRepository.removeAll());
    verifyNever(centralSystemRepository.setAppRunnedAnyTime());
    expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
  });

  test('''should call the userRepository relogin method
  when there is a Left( ServerFailure(UNHAUTORAIZED) )''', ()async{
    when(classX.functionX()).thenAnswer((realInvocation) async => Left(ServerFailure(type: ServerFailureType.UNHAUTORAIZED)));
    final result = await errorHandler.executeFunctionOld(classX.functionX);
    verify(classX.functionX()).called(2);
    verify(userRepository.reLogin());
    expect(result, Left(ServerFailure(type: ServerFailureType.UNHAUTORAIZED)));
  });

  test('''should call the userRepository relogin method
  when there is a Left( ServerFailure(Authorization) )''', ()async{
    when(classX.functionX()).thenAnswer((realInvocation) async => Left(ServerFailure(type: ServerFailureType.LOGIN)));
    final result = await errorHandler.executeFunctionOld(classX.functionX);
    verify(classX.functionX());
    verifyNever(userRepository.reLogin());
    expect(result, Left(ServerFailure(type: ServerFailureType.LOGIN)));
  });

  // new version of function
  test('should call the param function', ()async{
    when(classX.functionX()).thenAnswer( (_) async => Right(1) );
    await errorHandler.executeFunction<int>(classX.functionX);
    verify(classX.functionX());
  });

  test('should return the functionX returned value when all goes good', ()async{
    when(classX.functionX()).thenAnswer( (_) async => Right(1) );
    final result = await errorHandler.executeFunction<int>(classX.functionX);
    expect(result, Right(1));
  });

  test('''should call the centralSystemRepository deleteAll and init methods 
  when there is a Left( StorageFailure(PLATFORM) )''', ()async{
    when(classX.functionX()).thenAnswer((realInvocation) async => Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    final result = await errorHandler.executeFunction<int>(classX.functionX);
    verify(classX.functionX()).called(2);
    verify(centralSystemRepository.removeAll());
    verify(centralSystemRepository.setAppRunnedAnyTime());
    expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
  });

  test('''should call the centralSystemRepository deleteAll and init methods 
  when there is a Left( StorageFailure(PLATFORM) )''', ()async{
    when(classX.functionX()).thenAnswer((realInvocation) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    final result = await errorHandler.executeFunction<int>(classX.functionX);
    verify(classX.functionX()).called(1);
    verifyNever(centralSystemRepository.removeAll());
    verifyNever(centralSystemRepository.setAppRunnedAnyTime());
    expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
  });

  test('''should call the userRepository relogin method
  when there is a Left( ServerFailure(UNHAUTORAIZED) )''', ()async{
    when(classX.functionX()).thenAnswer((realInvocation) async => Left(ServerFailure(type: ServerFailureType.UNHAUTORAIZED)));
    final result = await errorHandler.executeFunction<int>(classX.functionX);
    verify(classX.functionX()).called(2);
    verify(userRepository.reLogin());
    expect(result, Left(ServerFailure(type: ServerFailureType.UNHAUTORAIZED)));
  });

  test('''should call the userRepository relogin method
  when there is a Left( ServerFailure(Authorization) )''', ()async{
    when(classX.functionX()).thenAnswer((realInvocation) async => Left(ServerFailure(type: ServerFailureType.LOGIN)));
    final result = await errorHandler.executeFunction<int>(classX.functionX);
    verify(classX.functionX());
    verifyNever(userRepository.reLogin());
    expect(result, Left(ServerFailure(type: ServerFailureType.LOGIN)));
  });
}
