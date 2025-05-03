import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/spot_repository.dart';
import 'package:hoora/tools.dart';
import 'package:latlong2/latlong.dart';
import '../../model/city_model.dart';
import '../../model/region_model.dart';
import '../../repository/region_repository.dart';
part 'nearby_spots_loading_event.dart';
part 'nearby_spots_loading_state.dart';

class NearbySpotsLoadingBloc extends Bloc<NearbySpotsLoadingEvent, NearbySpotsLoadingState> {
  final SpotRepository spotRepository;
  final CrashRepository crashRepository;
  final RegionRepository areaRepository;
  late List<Region> regions;
  late List<Spot> spots;

  NearbySpotsLoadingBloc({
    required this.spotRepository,
    required this.areaRepository,
    required this.crashRepository,
  }) : super(NearbySpotsLoadingLoading()) {
    on<SearchNearBySpots>(searchNearBySpots);
    on<NearbySpotsLoading>(loading);
  }
  void loading(NearbySpotsLoading event, Emitter<NearbySpotsLoadingState> emit) async{
    emit(NearbySpotsLoadingLoading());
  }
  void searchNearBySpots(SearchNearBySpots event, Emitter<NearbySpotsLoadingState> emit) async {
    try {
      emit(NearbySpotsLoadingLoading());

      if(Region.allRegions.isEmpty){
        Region.allRegions = await areaRepository.getAllRegions();
      }
      regions = Region.allRegions;

      spots = await findClosestSpots(event.userPosition);

      emit(NearbySpotsLoaded(spots: spots,pos: event.userPosition));
    } catch (exception) {
      /// Report crash to Crashlytics
      ////crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(NearbySpotsLoadingFailed(exception: alertException));
    }
  }
  Future<List<Spot>> findClosestSpots(userPosition) async {
    Region r = Tools.findClosestRegion(regions, userPosition);
    City city = Tools.findClosestCity(r.cities, userPosition);
    List<Spot> spots = await spotRepository.getSpotsByCity2(city);
    ///closest spots by distance of 1-km meter
    spots = Tools.findClosestSpotsByThreshold(spots, userPosition,1000);
    //spots = Tools.findClosestSpots(spots, userPosition);
    return spots;
  }
}
