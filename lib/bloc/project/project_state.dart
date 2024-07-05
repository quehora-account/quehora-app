part of 'project_bloc.dart';

sealed class ProjectState {}

final class InitLoading extends ProjectState {}

final class InitSuccess extends ProjectState {}

final class InitFailed extends ProjectState {
  final AlertException exception;

  InitFailed({required this.exception});
}

final class DonateLoading extends ProjectState {}

final class DonateSuccess extends ProjectState {
  final int gem;

  DonateSuccess({required this.gem});
}

final class DonateFailed extends ProjectState {
  final AlertException exception;

  DonateFailed({required this.exception});
}
