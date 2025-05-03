import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/company_model.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/repository/company_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:latlong2/latlong.dart';

import '../../model/region_model.dart';
import '../../model/unlocked_offer_model.dart';
import '../../repository/offer_repository.dart';
import '../../repository/region_repository.dart';
import '../../tools.dart';

part 'spot_page_event.dart';
part 'spot_page_state.dart';

class SpotPageBloc extends Bloc<SpotPageEvent, SpotPageState> {
  final CrashRepository crashRepository;
  final OfferRepository offerRepository;
  final RegionRepository areaRepository;
  final CompanyRepository companyRepository;
  late List<Region> regions;

  SpotPageBloc({
    required this.crashRepository,
    required this.offerRepository,
    required this.companyRepository,
    required this.areaRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
  }

  void initialize(Init event, Emitter<SpotPageState> emit) async {
    try {
      emit(InitLoading());

      if(Region.allRegions.isEmpty){
        Region.allRegions = await areaRepository.getAllRegions();
      }
      regions = Region.allRegions;
      List<Offer> offers = [];
      var companies = await companyRepository.getAllCompanies();
      var offers2 = await findClosestOffers(event.cityId,event.spotPosition);
      var unlockedOffers= await offerRepository.getUnlockedOffers();
      for (var i = 0 ; i<offers2.length;i++) {
        var offer = offers2[i];
        /// Skip unlocked offer
        bool isUnlocked = false;
        for (UnlockedOffer unlockedOffer in unlockedOffers) {
          if (offer.id == unlockedOffer.offerId) {
            isUnlocked = true;
            break;
          }
        }
        if(!isUnlocked){
          /// Link company to offer
          for (Company company in companies) {
            if (offer.companyId == company.id) {
              offer.company = company;
              break;
            }
          }
          offers.add(offer);
        }
      }
      emit(InitSuccess(offers: offers));
    } catch (exception) {
      /// Report crash to Crashlytics
      //crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }
  Future<List<Offer>> findClosestOffers(cityId,spotPosition) async {
    List<Offer> offers = await offerRepository.getOffersByCity(cityId);
    debugPrint("dick${offers.length}");
    ///closest offers by distance of 1-km meter
    offers = Tools.findClosestOffersByThreshold(offers, spotPosition,1000,cityId);
    debugPrint("dick${offers.length}");

    return offers;
  }
}
