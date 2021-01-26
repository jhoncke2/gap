part of 'commented_images_widgets_bloc.dart';

@immutable
abstract class CommentedImagesWidgetsState {}

class CommentedImagesWidgetsInitialState extends CommentedImagesWidgetsState {}

class CommentedLoadedImagesWidgetsState extends CommentedImagesWidgetsState{
  final int nPaginasDeWidgets;
  final int nWidgetsPerPage;
  final List<List<Widget>> _commentedImageswidgetsPerPage;

  CommentedLoadedImagesWidgetsState({
    this.nPaginasDeWidgets, 
    this.nWidgetsPerPage, 
    @required List<List<Widget>> commentedImageswidgetsPerPage
  }):
    _commentedImageswidgetsPerPage = commentedImageswidgetsPerPage
    ;
  
  List<Widget>  getWidgetsByIndex(int index){
    return _commentedImageswidgetsPerPage[index];
  }
}