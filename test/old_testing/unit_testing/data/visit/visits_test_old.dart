import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:test/test.dart';

import 'visits_map.dart';

List<VisitOld> visits;

/*
void main(){
  group('Probando métodos en base a .fromJson', (){
    _testFromJson();
    _testListOfVisits();
  });
}
*/

Future _testFromJson()async{
  test('probando método fromJson', ()async{
    final Map<String, dynamic> data = await getDataAsJson();
    visits = visitsFromJson(data);
  });
}

Future _testListOfVisits()async{
  test('probando método fromJson', ()async{
    for(int i = 0; i < visits.length; i++){
      _expectVisit(visits[i], i);
    }
  });
}

void _expectVisit(VisitOld visit, int visitIndex){
  expect(visit.id, isNotNull);
  expect(visit.completo, isNotNull);
  expect(visit.date, isNotNull);
  expect(visit.sede, isNotNull);
  if(visitIndex == 0)
    expect(visit.formularios.length, 2);
  else if(visitIndex == 1)
    expect(visit.formularios.length, 1);
}