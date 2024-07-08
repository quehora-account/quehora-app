part of 'create_crowd_report_bloc.dart';

sealed class CreateCrowdReportEvent {}

final class IsAlreadyReported extends CreateCrowdReportEvent {
  final String spotId;

  IsAlreadyReported({required this.spotId});
}

final class CreateCrowdReport extends CreateCrowdReportEvent {
  final String duration;
  final String spotId;
  final int intensity;

  CreateCrowdReport(
      {required this.duration,
      required this.spotId,
      required this.intensity,
      });
}
