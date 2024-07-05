import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/donation_model.dart';
import 'package:hoora/model/organization_model.dart';
import 'package:hoora/model/project_model.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/organization_repository.dart';
import 'package:hoora/repository/project_repository.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final CrashRepository crashRepository;
  final OrganizationRepository organizationRepository;
  final ProjectRepository projectRepository;

  late List<Donation> donations;
  late List<Project> projects;

  ProjectBloc({
    required this.crashRepository,
    required this.projectRepository,
    required this.organizationRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
    on<Donate>(donate);
  }

  void initialize(Init event, Emitter<ProjectState> emit) async {
    try {
      emit(InitLoading());

      List futures = await Future.wait([
        organizationRepository.getAllOrganizations(),
        projectRepository.getAllProjects(),
        projectRepository.getDonations(),
      ]);

      List<Organization> organizations = futures[0];
      projects = futures[1];
      donations = futures[2];

      for (Project project in projects) {
        for (Organization organization in organizations) {
          if (organization.id == project.organizationId) {
            project.organization = organization;
            break;
          }
        }
      }

      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  void donate(Donate event, Emitter<ProjectState> emit) async {
    try {
      emit(DonateLoading());

      /// Create donation
      await projectRepository.createDonation(event.project.id, event.gem);

      /// Get donation
      Donation donation = await projectRepository.getDonation(event.project.id);

      /// Add donation to donations
      donations.add(donation);

      /// Update project collected
      for (Project project in projects) {
        if (project.id == event.project.id) {
          project.collected += event.gem;
          break;
        }
      }

      emit(DonateSuccess(gem: event.gem));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(DonateFailed(exception: alertException));
    }
  }
}
