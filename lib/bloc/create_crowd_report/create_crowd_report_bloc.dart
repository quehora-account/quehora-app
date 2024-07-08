import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/repository/crowd_report_repository.dart';
import 'package:hoora/repository/crash_repository.dart';

part 'create_crowd_report_event.dart';
part 'create_crowd_report_state.dart';

class CreateCrowdReportBloc extends Bloc<CreateCrowdReportEvent, CreateCrowdReportState> {
  final CrashRepository crashRepository;
  final CrowdReportRepository crowdReportRepository;

  CreateCrowdReportBloc({
    required this.crashRepository,
    required this.crowdReportRepository,
  }) : super(ReportAlreadyCreatedLoading()) {
    on<CreateCrowdReport>(createCrowdReport);
    on<IsAlreadyReported>(isAlreadyReported);
  }

  void createCrowdReport(CreateCrowdReport event, Emitter<CreateCrowdReportState> emit) async {
    try {
      emit(CreateCrowdReportLoading());
      await crowdReportRepository.createCrowdReport(
          event.spotId, event.intensity, event.duration);

      emit(CreateCrowdReportSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(CreateCrowdReportFailed(exception: alertException));
    }
  }

  void isAlreadyReported(IsAlreadyReported event, Emitter<CreateCrowdReportState> emit) async {
    try {
      emit(ReportAlreadyCreatedLoading());

      bool alreadyCreated = await crowdReportRepository.crowdReportAlreadyCreated(event.spotId);

      if (alreadyCreated) {
        emit(ReportAlreadyCreated());
        return;
      }
      emit(ReportNotAlreadyCreated());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(CreateCrowdReportFailed(exception: alertException));
    }
  }
}
