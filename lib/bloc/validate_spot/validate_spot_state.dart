part of 'validate_spot_bloc.dart';

sealed class ValidateSpotState {}

final class ValidateSpotSuccess extends ValidateSpotState {
  final int gems;

  ValidateSpotSuccess({required this.gems});
}

final class SpotAlreadyValidated extends ValidateSpotState {}

final class ValidateSpotLoading extends ValidateSpotState {}

final class ValidateSpotFailed extends ValidateSpotState {
  final AlertException exception;

  ValidateSpotFailed({required this.exception});
}
