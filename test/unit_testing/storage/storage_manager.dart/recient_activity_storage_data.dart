import 'dart:convert';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/data/models/entities/entities.dart';

final Map<String, String> data = {
  'chosen_project':chosenProjectAsString,
  'visits': visitsAsString,
  'chosen_visit':chosenVisitAsString,
  'formularios': formsAsString,
  'chosen_form':chosenFormAsString,
  'commented_images':commentedImagesAsString
};
final String chosenProjectAsString = jsonEncode(fakeData.projects[0].toJson());
final String visitsAsString = jsonEncode(Visits(visits: fakeData.visits).toJson());
final String chosenVisitAsString = jsonEncode(fakeData.visits[0].toJson());
final String formsAsString = jsonEncode(Formularios(formularios: fakeData.formularios).toJson());
final String chosenFormAsString = jsonEncode(fakeData.formularios[0].toJson());
final String commentedImagesAsString = jsonEncode(CommentedImages(commentedImages: fakeData.commentedImages).toJson());
  //2021-02-10T16:30:14.944275
