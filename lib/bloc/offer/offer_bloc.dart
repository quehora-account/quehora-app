import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/company_model.dart';
import 'package:hoora/model/level_model.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/model/unlocked_offer_model.dart';
import 'package:hoora/repository/company_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/level_repository.dart';
import 'package:hoora/repository/offer_repository.dart';
import 'package:hoora/repository/region_repository.dart';

import '../../model/city_model.dart';
import '../../model/region_model.dart';

part 'offer_event.dart';
part 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final CrashRepository crashRepository;
  final OfferRepository offerRepository;
  final CompanyRepository companyRepository;
  final LevelRepository levelRepository;
  final RegionRepository areaRepository;

  List<List<Offer>> categories = [];
  List<UnlockedOffer> unlockedOffers = [];
  List<Company> companies = [];
  late List<Region> regions;
  String searchText = "";
  OfferBloc({
    required this.crashRepository,
    required this.offerRepository,
    required this.companyRepository,
    required this.levelRepository,
    required this.areaRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
    on<FirstTime>(firstTIme);
    on<SearchOffers>(searchOffers);
    on<CitySelected>(citySelected);
    on<EmptySuggestions>((EmptySuggestions event, Emitter<OfferState> emit)async{
      emit(SuggestionEmptied());
    });
    on<GetSuggestions>(returnSuggestions);
    on<Unlock>(unlock);
  }

  void initialize(Init event, Emitter<OfferState> emit) async {
    try {
      emit(InitLoading());

      /// Fetch companies, offers and unlocked offers
      List futures = await Future.wait([
        companyRepository.getAllCompanies(),
        offerRepository.getOffers(),
        offerRepository.getUnlockedOffers(),
        levelRepository.getAllLevels()
      ]);

      Level.levels = futures[3];

      Level.levels.sort((a, b) {
        return a.level.compareTo(b.level);
      });

      companies = futures[0];
      List<Offer> offers = futures[1];
      unlockedOffers = futures[2];

      categories = [];

      /// Init categories
      for (Level _ in Level.levels) {
        categories.add([]);
      }

      for (Offer offer in offers) {
        /// Skip unlocked offer
        bool isUnlocked = false;
        for (UnlockedOffer unlockedOffer in unlockedOffers) {
          if (offer.id == unlockedOffer.offerId) {
            isUnlocked = true;
            break;
          }
        }
        if (isUnlocked) {
          continue;
        }

        /// Link company to offer
        for (Company company in companies) {
          if (offer.companyId == company.id) {
            offer.company = company;
            break;
          }
        }

        /// Split into categorie
        categories[offer.levelRequired - 1].add(offer);
      }

      /// Sorting by priority
      for (List<Offer> offers in categories) {
        offers.sort((a, b) => a.priority.compareTo(b.priority));
      }
      if(Region.allRegions.isEmpty){
        Region.allRegions = await areaRepository.getAllRegions();
      }
      regions = Region.allRegions;
      emit(InitSuccess());
    } catch (exception) {
      /// Report crash to Crashlytics
      //crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }
  void firstTIme(FirstTime event, Emitter<OfferState> emit) async {
    try {
      emit(InitLoading());
      companies = await companyRepository.getAllCompanies();
      List<Offer> offers = await offerRepository.getOffers();

      categories = [];

      /// Init categories
      for (Level _ in Level.levels) {
        categories.add([]);
      }

      for (Offer offer in offers) {
        /// Skip unlocked offer
        bool isUnlocked = false;
        for (UnlockedOffer unlockedOffer in unlockedOffers) {
          if (offer.id == unlockedOffer.offerId) {
            isUnlocked = true;
            break;
          }
        }
        if (isUnlocked) {
          continue;
        }

        /// Link company to offer
        for (Company company in companies) {
          if (offer.companyId == company.id) {
            offer.company = company;
            break;
          }
        }

        /// Split into categorie
        categories[offer.levelRequired - 1].add(offer);
      }

      /// Sorting by priority
      for (List<Offer> offers in categories) {
        offers.sort((a, b) => a.priority.compareTo(b.priority));
      }
      emit(FirstTimeSuccess(categories: categories));
    } catch (exception) {
      /// Report crash to Crashlytics
      //crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  void citySelected(CitySelected event, Emitter<OfferState> emit) async {
    try {
      //emit(SpotsLoading());
      categories = [];

      /// Init categories
      for (Level _ in Level.levels) {
        categories.add([]);
      }
      searchText = event.city.name;
      var offers  = await offerRepository.getCityAndOnlineOffers(event.city.id);
      debugPrint("hay hay ${offers.length}");
      if(offers.isNotEmpty){
        for (Offer offer in offers) {
          /// Skip unlocked offer
          bool isUnlocked = false;
          for (UnlockedOffer unlockedOffer in unlockedOffers) {
            if (offer.id == unlockedOffer.offerId) {
              isUnlocked = true;
              break;
            }
          }
          if (isUnlocked) {
            continue;
          }

          /// Link company to offer
          for (Company company in companies) {
            if (offer.companyId == company.id) {
              offer.company = company;
              break;
            }
          }

          /// Split into categorie
          categories[offer.levelRequired - 1].add(offer);
        }
        for (List<Offer> offers in categories) {
          offers.sort((a, b) => a.priority.compareTo(b.priority));
        }
      }
      emit(GetOffersSuccess(searchText: event.city.name,doesFind: offers.isNotEmpty,categories: categories));
      if (emit.isDone) return;
    } catch (error) {
      AlertException alertException = AlertException.fromException(error);
      if (emit.isDone) return;
      emit(InitFailed(exception: alertException));
    }
    //emit(InitSuccess(categories: categories));
  }
  void returnSuggestions(GetSuggestions event, Emitter<OfferState> emit) async {
    var suggestionList = [];
    if(event.search.isNotEmpty){
      var suggestionCities = [];
      for(Region region in regions){
        for(City city in region.cities){
          if(city.name.toLowerCase().contains(event.search.toLowerCase())){
            suggestionCities.add(city);
            if(suggestionCities.length==10){
              break;
            }
          }
        }
      }
      suggestionList.addAll(suggestionCities);
    }

    emit(GetSuggestionsSuccess(suggestion: suggestionList));
  }
  void searchOffers(SearchOffers event, Emitter<OfferState> emit) async {
    searchText = event.search;
    categories = [];
    for (Level _ in Level.levels) {
      categories.add([]);
    }
    var cityAndOffers  = await offerRepository.getOffersBySearch(searchText,regions);
    if(cityAndOffers.offers.isNotEmpty){
      for (Offer offer in cityAndOffers.offers) {
        /// Skip unlocked offer
        bool isUnlocked = false;
        for (UnlockedOffer unlockedOffer in unlockedOffers) {
          if (offer.id == unlockedOffer.offerId) {
            isUnlocked = true;
            break;
          }
        }
        if (isUnlocked) {
          continue;
        }

        /// Link company to offer
        for (Company company in companies) {
          if (offer.companyId == company.id) {
            offer.company = company;
            break;
          }
        }

        /// Split into categorie
        categories[offer.levelRequired - 1].add(offer);
      }
      for (List<Offer> offers in categories) {
        offers.sort((a, b) => a.priority.compareTo(b.priority));
      }
    }
    emit(GetOffersSuccess(searchText: cityAndOffers.city!=null?cityAndOffers.city!.name:event.search,doesFind: cityAndOffers.offers.isNotEmpty,categories: categories));
    // await _fetchSpots(emit);
  }


  void unlock(Unlock event, Emitter<OfferState> emit) async {
    try {
      emit(UnlockLoading());

      /// Unlock offer
      await offerRepository.unlockOffer(event.offer.id);

      /// Split into level list
      if(!event.isFromSpotPage){
        List<Offer> offers = categories[event.offer.levelRequired - 1];
        for (int i = 0; i < offers.length; i++) {
          if (event.offer.id == offers[i].id) {
            offers.removeAt(i);
            break;
          }
        }
      }

      /// Fetch the unlocked offer
      UnlockedOffer unlockedOffer = await offerRepository.getUnlockedOffer(event.offer.id);

      emit(UnlockSuccess(unlockedOffer: unlockedOffer));
    } catch (exception) {
      /// Report crash to Crashlytics
      ////crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UnlockFailed(exception: alertException));
    }
  }
}
