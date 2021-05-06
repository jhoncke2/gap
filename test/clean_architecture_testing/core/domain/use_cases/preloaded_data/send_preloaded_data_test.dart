import 'package:gap/clean_architecture_structure/core/domain/repositories/preloaded_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/preloaded/send_preloaded_data.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockPreloadedRepository extends Mock implements PreloadedRepository{}

SendPreloadedData useCase;
MockPreloadedRepository repository;

void main(){
  setUp((){
    repository = MockPreloadedRepository();
    useCase = SendPreloadedData(
      repository: repository
    );
  });

  group('sendPreloadedData', (){
    test('should call the method sendPreloadedData from the repository', ()async{
      await useCase.call(NoParams());
      verify(repository.sendPreloadedData());
    });
  });
}