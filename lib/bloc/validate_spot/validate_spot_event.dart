part of 'validate_spot_bloc.dart';

sealed class ValidateSpotEvent {}

final class ValidateSpot extends ValidateSpotEvent {
  final Spot spot;
  final List coordinates;

  ValidateSpot({
    required this.spot,
    required this.coordinates,
  });
}
