import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/images/images_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_singleton.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';

class BlocProvidersCreator{
  static final UserOldBloc userBloc = UserOldBloc();
  static final ProjectsOldBloc projectsBloc = ProjectsOldBloc();
  static final VisitsOldBloc visitsBloc = VisitsOldBloc();
  static final FormulariosOldBloc formulariosBloc = FormulariosOldBloc();
  static final IndexOldBloc indexBloc = IndexOldBloc();
  static final ChosenFormBloc chosenFormBloc = ChosenFormBloc();
  static final ImagesOldBloc imagesBloc = ImagesOldBloc();
  static final CommentedImagesBloc commentedImagesBloc = CommentedImagesBloc();
  static final FirmPaintBloc firmPaintBloc = FirmPaintBloc();
  static final VisitsSingleton visitsSingleton = VisitsSingleton();
  static final KeyboardListenerBloc keyboardListenerBloc = KeyboardListenerBloc();

  static final blocProviders = [
    BlocProvider<ProjectsOldBloc>(create: (_)=>projectsBloc),
    BlocProvider<VisitsOldBloc>(create: (_)=>visitsBloc),
    BlocProvider<FormulariosOldBloc>(create: (_)=>formulariosBloc),
    BlocProvider<IndexOldBloc>(create: (_)=>indexBloc),
    BlocProvider<ChosenFormBloc>(create: (_)=>chosenFormBloc),
    BlocProvider<ImagesOldBloc>(create: (_)=>imagesBloc),
    BlocProvider<CommentedImagesBloc>(create: (_)=>commentedImagesBloc),
    BlocProvider<FirmPaintBloc>(create: (_)=>firmPaintBloc),
    BlocProvider<UserOldBloc>(create: (_)=>userBloc),
    BlocProvider<KeyboardListenerBloc>(create: (_)=>keyboardListenerBloc)
  ];

  static final singletones = [
    visitsSingleton
  ];

  static void dispose(){
    userBloc.close();
    projectsBloc.close();
    visitsBloc.close();
    formulariosBloc.close();
    indexBloc.close();
    chosenFormBloc.close();
    imagesBloc.close();
    commentedImagesBloc.close();
    firmPaintBloc.close();
    keyboardListenerBloc.close();
  }

  static Map<BlocName, Bloc> get blocsAsMap => {
    BlocName.Projects: projectsBloc,
    BlocName.Visits: visitsBloc,
    BlocName.Formularios: formulariosBloc,
    BlocName.Index: indexBloc,
    BlocName.ChosenForm: chosenFormBloc,
    BlocName.Images: imagesBloc,
    BlocName.CommentedImages: commentedImagesBloc,
    BlocName.FirmPaint: firmPaintBloc,
    BlocName.User: userBloc,
  };

  static Map<BlocName, ChangeNotifier> get singletonesAsMap => {
    BlocName.VisitsSingleton: visitsSingleton
  };
}