import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/spot_repository.dart';
import 'package:latlong2/latlong.dart';

import '../../model/region_model.dart';
import '../../repository/region_repository.dart';

part 'validate_spot_event.dart';
part 'validate_spot_state.dart';

class ValidateSpotBloc extends Bloc<ValidateSpotEvent, ValidateSpotState> {
  final SpotRepository spotRepository;
  final CrashRepository crashRepository;
  final RegionRepository areaRepository;
  late List<Region> regions;
  late List<Spot> spots;
  late LatLng userPosition;

  ValidateSpotBloc({
    required this.spotRepository,
    required this.areaRepository,
    required this.crashRepository,
  }) : super(ValidateSpotLoading2()) {
    on<ValidateSpot>(validateSpot);
    on<ValidateSpotLoadingEvent>(loading);
  }
  void loading(ValidateSpotLoadingEvent event, Emitter<ValidateSpotState> emit) async{
    emit(ValidateSpotLoading());
  }
  void validateSpot(ValidateSpot event, Emitter<ValidateSpotState> emit) async {

    try {
      emit(ValidateSpotLoading());
     
      bool alreadyValidated = await spotRepository.spotAlreadyValidated(event.spot);

      if (alreadyValidated) {
        emit(SpotAlreadyValidated());
        return;
      }
      await spotRepository.validateSpot(event.spot, event.coordinates);
      emit(ValidateSpotSuccess(gems: event.spot.getGemsNow(),spot: event.spot));
    } catch (exception) {
      /// Report crash to Crashlytics
      ////crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ValidateSpotFailed(exception: alertException));
    }
  }
}
