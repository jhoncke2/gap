part of 'commented_images_widgets_bloc.dart';

@immutable
abstract class CommentedImagesWidgetsState {}

class CommentedImagesWidgetsInitial extends CommentedImagesWidgetsState {}

class CommentedLoadedImagesWidgets extends CommentedImagesWidgetsState{
  final int nPaginasDeWidgets;
  final int widgetsPerPage;
  final List<List<Widget>> _commentedImageswidgetsPerPage;

  CommentedLoadedImagesWidgets({
    this.nPaginasDeWidgets, 
    this.widgetsPerPage, 
    @required List<List<Widget>> commentedImageswidgetsPerPage
  }):
    _commentedImageswidgetsPerPage = commentedImageswidgetsPerPage
    ;
  
  List<Widget>  getWidgetsByIndex(int index){
    return _commentedImageswidgetsPerPage[index];
  }
}