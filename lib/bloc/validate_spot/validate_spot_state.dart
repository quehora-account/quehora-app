part of 'validate_spot_bloc.dart';

sealed class ValidateSpotState {}

final class ValidateSpotSuccess extends ValidateSpotState {
  final int gems;
  final Spot spot;
  ValidateSpotSuccess({required this.gems,required this.spot});
}

final class SpotAlreadyValidated extends ValidateSpotState {}

final class ValidateSpotLoading extends ValidateSpotState {}
final class ValidateSpotLoading2 extends ValidateSpotState {}

final class ValidateSpotFailed extends ValidateSpotState {
  final AlertException exception;

  ValidateSpotFailed({required this.exception});
}
