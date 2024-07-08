import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/common/globals.dart';

part 'first_launch_event.dart';
part 'first_launch_state.dart';

class FirstLaunchBloc extends Bloc<FirstLaunchEvent, FirstLaunchState> {
  FirstLaunchBloc() : super(FirstLaunchInitial()) {
    on<RequestGeolocation>(getGeolocation);
    on<SetFirstLaunch>(setFirstLaunch);
  }

  void setFirstLaunch(SetFirstLaunch event, Emitter<FirstLaunchState> emit) async {
    (await SharedPreferences.getInstance())
        .setString(AppConstants.kSSKeyFirstLaunch, "false");
    emit(FirstLaunchSet());
  }

  void getGeolocation(RequestGeolocation event, Emitter<FirstLaunchState> emit) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(GeolocationDenied());
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        emit(GeolocationDenied());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(GeolocationForeverDenied());
      return;
    }

    emit(GeolocationAccepted());
  }
}
