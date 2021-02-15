import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/images/images_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';

class BlocProvidersCreator{
  static final UserBloc userBloc = UserBloc();
  static final ProjectsBloc projectsBloc = ProjectsBloc();
  static final VisitsBloc visitsBloc = VisitsBloc();
  static final FormulariosBloc formulariosBloc = FormulariosBloc();
  static final IndexBloc indexBloc = IndexBloc();
  static final ChosenFormBloc chosenFormBloc = ChosenFormBloc();
  static final ImagesBloc imagesBloc = ImagesBloc();
  static final CommentedImagesBloc commentedImagesBloc = CommentedImagesBloc();
  static final FirmPaintBloc firmPaintBloc = FirmPaintBloc();

  static final blocProviders = [
    BlocProvider<ProjectsBloc>(create: (_)=>projectsBloc),
    BlocProvider<VisitsBloc>(create: (_)=>visitsBloc),
    BlocProvider<FormulariosBloc>(create: (_)=>formulariosBloc),
    BlocProvider<IndexBloc>(create: (_)=>indexBloc),
    BlocProvider<ChosenFormBloc>(create: (_)=>chosenFormBloc),
    BlocProvider<ImagesBloc>(create: (_)=>imagesBloc),
    BlocProvider<CommentedImagesBloc>(create: (_)=>commentedImagesBloc),
    BlocProvider<FirmPaintBloc>(create: (_)=>firmPaintBloc),
    BlocProvider<UserBloc>(create: (_)=>userBloc),
  ];

  static void dispose(){
    projectsBloc.close();
    visitsBloc.close();
    formulariosBloc.close();
    indexBloc.close();
    chosenFormBloc.close();
    imagesBloc.close();
    commentedImagesBloc.close();
    firmPaintBloc.close();    
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
    BlocName.UserBloc: userBloc
  };
}