import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/spot_repository.dart';

part 'validate_spot_event.dart';
part 'validate_spot_state.dart';

class ValidateSpotBloc extends Bloc<ValidateSpotEvent, ValidateSpotState> {
  final SpotRepository spotRepository;
  final CrashRepository crashRepository;

  ValidateSpotBloc({
    required this.spotRepository,
    required this.crashRepository,
  }) : super(ValidateSpotLoading()) {
    on<ValidateSpot>(validateSpot);
  }


  void validateSpot(ValidateSpot event, Emitter<ValidateSpotState> emit) async {

    try {
      emit(ValidateSpotLoading());
     
      bool alreadyValidated =
          await spotRepository.spotAlreadyValidated(event.spot);

      if (alreadyValidated) {
        emit(SpotAlreadyValidated());
        return;
      }
      await spotRepository.validateSpot(event.spot);
      emit(ValidateSpotSuccess(gems: event.spot.getGemsNow()));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ValidateSpotFailed(exception: alertException));
    }
  }
}
