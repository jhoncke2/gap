import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixture_reader.dart';

String tStringFormularios;
List<Map<String, dynamic>> tJsonFormularios;
Map<String, dynamic> tJsonFormulario;
FormularioModel tFormulario;

void main(){
  setUp((){
    tStringFormularios = callFixture('formularios.json');
    tJsonFormularios = jsonDecode(tStringFormularios).cast<Map<String, dynamic>>();
    tJsonFormulario = tJsonFormularios[0];
  });

  group('fromJson', (){
    setUp((){
      tFormulario = FormularioModel.fromJson(tJsonFormulario);
    });

    test('Should execute the formJson successfuly', ()async{
      expect(tFormulario.formStep, FormStep.Finished);
      expect(tFormulario.stage, ProcessStage.Realizada);
    });
  });

  group('toJson', (){
    setUp((){
      tFormulario = FormularioModel.fromJson(tJsonFormulario);
    });

    test('Should execute the formJson successfuly', ()async{
      final Map<String, dynamic> jsonFormulario = tFormulario.toJson();
      expect(jsonFormulario, tJsonFormulario);
    });
  });
}