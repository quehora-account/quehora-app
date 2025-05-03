part of 'spot_page_bloc.dart';

sealed class SpotPageEvent {}

final class Init extends SpotPageEvent {
  final String cityId;
  LatLng spotPosition;

  Init({
    required this.cityId,
    required this.spotPosition
  });
}
