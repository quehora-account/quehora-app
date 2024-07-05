part of 'validate_spot_bloc.dart';

sealed class ValidateSpotEvent {}

final class ValidateSpot extends ValidateSpotEvent {
  final Spot spot;

  ValidateSpot({required this.spot});
}
