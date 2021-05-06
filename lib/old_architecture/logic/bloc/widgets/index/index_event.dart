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
  final void Function(int) onEnd;
  ChangeNPages({
    @required this.nPages,
    this.onEnd
  });
}

class ChangeIndexPage extends IndexEvent{
  final Function() onEnd;
  final int newIndexPage;
  ChangeIndexPage({
    @required this.newIndexPage,
    this.onEnd
  });
}

class ResetAllOfIndex extends IndexEvent{}

