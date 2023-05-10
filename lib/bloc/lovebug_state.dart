part of 'lovebug_bloc.dart';

abstract class LovebugState {}

class LoveBugState extends LovebugState {
  Lovebug lovebug;
  LoveBugState(
    this.lovebug
  );
}
