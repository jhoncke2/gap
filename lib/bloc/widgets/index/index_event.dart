part of 'index_bloc.dart';

@immutable
abstract class IndexEvent {}

class ChangeIndexActivation extends IndexEvent{
  final bool isActive;
  ChangeIndexActivation({
    @required this.isActive
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

