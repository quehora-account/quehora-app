part of 'project_bloc.dart';

sealed class ProjectEvent {}

final class Init extends ProjectEvent {}

final class Donate extends ProjectEvent {
  final Project project;
  final int gem;

  Donate({required this.project, required this.gem});
}
