part of 'index_bloc.dart';

@immutable
class IndexState {
  final int nPages;
  final int currentIndex;
  final bool isActive;

  IndexState({
    this.nPages = 0,
    this.currentIndex, 
    this.isActive = false
  });

  IndexState copyWith({
    int nPages,
    int currentIndex,
    bool isActive,
   }) => IndexState(
    nPages: nPages??this.nPages,
    currentIndex: currentIndex??this.currentIndex,
    isActive: isActive??this.isActive,
  );
}
