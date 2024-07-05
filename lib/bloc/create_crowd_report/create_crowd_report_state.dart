part of 'create_crowd_report_bloc.dart';

sealed class CreateCrowdReportState {}

final class CreateCrowdReportSuccess extends CreateCrowdReportState {}

final class CreateCrowdReportLoading extends CreateCrowdReportState {}

final class ReportAlreadyCreated extends CreateCrowdReportState {}

final class ReportNotAlreadyCreated extends CreateCrowdReportState {}

final class ReportAlreadyCreatedLoading extends CreateCrowdReportState {}

final class CreateCrowdReportFailed extends CreateCrowdReportState {
  final AlertException exception;

  CreateCrowdReportFailed({required this.exception});
}
