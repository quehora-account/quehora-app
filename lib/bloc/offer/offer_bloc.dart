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

part 'offer_event.dart';
part 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final CrashRepository crashRepository;
  final OfferRepository offerRepository;
  final CompanyRepository companyRepository;
  final LevelRepository levelRepository;

  List<List<Offer>> categories = [];

  OfferBloc({
    required this.crashRepository,
    required this.offerRepository,
    required this.companyRepository,
    required this.levelRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
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

      List<Company> companies = futures[0];
      List<Offer> offers = futures[1];
      List<UnlockedOffer> unlockedOffers = futures[2];

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

      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  void unlock(Unlock event, Emitter<OfferState> emit) async {
    try {
      emit(UnlockLoading());

      /// Unlock offer
      await offerRepository.unlockOffer(event.offer.id);

      /// Split into level list
      List<Offer> offers = categories[event.offer.levelRequired - 1];
      for (int i = 0; i < offers.length; i++) {
        if (event.offer.id == offers[i].id) {
          offers.removeAt(i);
          break;
        }
      }

      /// Fetch the unlocked offer
      UnlockedOffer unlockedOffer = await offerRepository.getUnlockedOffer(event.offer.id);

      emit(UnlockSuccess(unlockedOffer: unlockedOffer));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UnlockFailed(exception: alertException));
    }
  }
}
