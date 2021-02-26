import 'package:gap/data/models/entities/entities.dart';
import 'package:test/test.dart';

import './projects_map.dart';

List<Project> projects;

void main(){
  group('Probando métodos en base a .fromJson', (){
    _testFromJson();
    _testListOfVisits();
  });
}

Future _testFromJson()async{
  test('probando método fromJson', ()async{
    final List<Map<String, dynamic>> data = await getDataAsJson();
    projects = projectsFromJson(data);
  });
}

Future _testListOfVisits()async{
  test('probando método fromJson', ()async{
    for(int i = 0; i < projects.length; i++){
      _expectVisit(projects[i], i);
    }
  });
}

void _expectVisit(Project project, int projectIndex){
  expect(project.id, isNotNull);
  expect(project.nombre, isNotNull);
  expect(project.visits, isNotNull);
  if(projectIndex == 0)
    expect(project.visits.length, 0);
  else if(projectIndex == 1)
    expect(project.visits.length, 2);
}