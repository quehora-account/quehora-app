part of 'first_launch_bloc.dart';

sealed class FirstLaunchEvent {}

class RequestGeolocation extends FirstLaunchEvent {}

class SetFirstLaunch extends FirstLaunchEvent {}
