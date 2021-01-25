part of 'index_bloc.dart';

@immutable
class IndexState {
  final int nPages;
  final int currentIndex;
  final List<Widget> showedItems;
  final bool canGoPrevious;
  final bool canGoNext;

  IndexState({
    this.nPages,
    this.currentIndex, 
    this.showedItems, 
    this.canGoPrevious, 
    this.canGoNext
  });

  IndexState copyWith({
    int nPages,
    int currentIndex,
    List<Widget> showedItems,    
    bool canGoPrevious,
    bool canGoNext,
  }) => IndexState(
    nPages: nPages??this.nPages,
    currentIndex: currentIndex??this.currentIndex,
    showedItems: showedItems??this.showedItems,
    canGoPrevious: canGoPrevious??this.canGoPrevious,
    canGoNext: canGoNext??this.canGoNext
  );
}
