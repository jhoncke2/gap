part of 'index_bloc.dart';

@immutable
abstract class IndexEvent {}

class ChangeSePuedeAvanzar extends IndexEvent{
  final bool sePuede;
  ChangeSePuedeAvanzar({
    @required this.sePuede
  });
}

class ChangeNPages extends IndexEvent{
  final int nPages;
  ChangeNPages({
    @required this.nPages
  });
}

class ChangeIndex extends IndexEvent{
  final int newIndex;
  ChangeIndex({
    @required this.newIndex
  });
}

class ResetAllOfIndex extends IndexEvent{}

