part of 'first_launch_bloc.dart';

sealed class FirstLaunchState {}

final class FirstLaunchInitial extends FirstLaunchState {}

final class GeolocationDenied extends FirstLaunchState {}

final class GeolocationForeverDenied extends FirstLaunchState {}

final class GeolocationAccepted extends FirstLaunchState {}

final class FirstLaunchSet extends FirstLaunchState {}
