import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/company_model.dart';
import 'package:hoora/model/level_model.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/model/unlocked_offer_model.dart';
import 'package:hoora/model/user_model.dart';
import 'package:hoora/repository/company_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/level_repository.dart';
import 'package:hoora/repository/offer_repository.dart';
import 'package:hoora/repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final OfferRepository offerRepository;
  final CompanyRepository companyRepository;
  final LevelRepository levelRepository;
  final CrashRepository crashRepository;

  late User user;
  late String email;
  late List<Offer> unlockedOffers;

  UserBloc({
    required this.companyRepository,
    required this.userRepository,
    required this.offerRepository,
    required this.levelRepository,
    required this.crashRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
    on<AddGem>(addGem);
    on<RemoveGem>(removeGem);
    on<SetNickname>(setNickname);
    on<UpdateProfile>(updateProfile);
    on<AddUnlockedOffer>(addUnlockedOffer);
    on<ActivateUnlockedOffer>(activateUnlockedOffer);
  }

  void initialize(Init event, Emitter<UserState> emit) async {
    try {
      emit(InitLoading());

      /// Fetch levels before others data
      /// User model need to have levels initialized.
      final List<Level> levels = await levelRepository.getAllLevels();

      /// Sorting using the level var.
      levels.sort((a, b) {
        return a.level.compareTo(b.level);
      });

      /// Levels will be stored as a static var.
      Level.levels = levels;

      /// Retrieving email from the user object in auth firebase.
      /// This is a sync method.
      email = userRepository.getEmail();

      /// Fetching datas
      List futures = await Future.wait([
        userRepository.getUser(),
        offerRepository.getUnlockedOffers(),
        offerRepository.getAllOffers(),
        companyRepository.getAllCompanies(),
      ]);

      /// Init datas
      user = futures[0];
      List<UnlockedOffer> unlockedOffers = futures[1];
      List<Offer> offers = futures[2];
      List<Company> companies = futures[3];

      this.unlockedOffers = [];
      for (Offer offer in offers) {
        /// Link company to offer
        for (Company company in companies) {
          if (offer.companyId == company.id) {
            offer.company = company;
            break;
          }
        }

        /// Link unlocked offer to offer
        for (UnlockedOffer unlockedOffer in unlockedOffers) {
          if (unlockedOffer.offerId == offer.id) {
            offer.unlockedOffer = unlockedOffer;
            this.unlockedOffers.add(offer);
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

  void addGem(AddGem event, Emitter<UserState> emit) {
    user.gem += event.gem;
    emit(GemsUpdate(gems: user.gem));
  }

  void removeGem(RemoveGem event, Emitter<UserState> emit) {
    user.gem -= event.gem;
    emit(GemsUpdate(gems: user.gem));
  }

  void addUnlockedOffer(AddUnlockedOffer event, Emitter<UserState> emit) {
    unlockedOffers.insert(0, event.offer);
    emit(UnlockedOffersUpdate(offers: unlockedOffers));
  }

  void setNickname(SetNickname event, Emitter<UserState> emit) async {
    try {
      emit(SetNicknameLoading());
      final isAvailable = await userRepository.isNicknameAvailable(event.nickname);
      if (!isAvailable) {
        emit(NicknameNotAvailable(nickname: event.nickname));
      } else {
        /// At this point levels are not initialized.
        /// The fetch of levels (such as cities) should be reworked.
        /// It could/should be fetch from the main, and stored as global.
        final List<Level> levels = await levelRepository.getAllLevels();

        /// Sorting using the level var.
        levels.sort((a, b) {
          return a.level.compareTo(b.level);
        });

        /// Levels will be stored as a static var.
        Level.levels = levels;
        await userRepository.setNickname(event.nickname);
        emit(SetNicknameSuccess());
      }
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SetNicknameFailed(exception: alertException));
    }
  }

  void updateProfile(UpdateProfile event, Emitter<UserState> emit) async {
    try {
      emit(UpdateProfileLoading());

      /// Verify nickname is unique
      if (event.hasNicknameChanged) {
        bool isAvailable = await userRepository.isNicknameAvailable(event.nickname);

        if (!isAvailable) {
          emit(NicknameNotAvailable(nickname: event.nickname));
          return;
        }
      }

      await userRepository.updateProfile(
        documentId: user.id,
        nickname: event.nickname,
        firstname: event.firstname,
        lastname: event.lastname,
        city: event.city,
        country: event.country,
        birthday: event.birthday,
        gender: event.gender,
      );
      user.nickname = event.nickname;
      user.firstname = event.firstname;
      user.lastname = event.lastname;
      user.city = event.city;
      user.country = event.country;
      user.birthday = event.birthday;
      user.gender = event.gender;
      emit(UpdateProfileSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateProfileFailed(exception: alertException));
    }
  }

  void activateUnlockedOffer(ActivateUnlockedOffer event, Emitter<UserState> emit) async {
    try {
      emit(ActivateUnlockedOfferLoading());

      await offerRepository.activateUnlockedOffer(event.offer.unlockedOffer!.id);

      for (Offer unlockedOffer in unlockedOffers) {
        if (event.offer.id == unlockedOffer.id) {
          unlockedOffer.unlockedOffer!.status = UnlockedOfferStatus.activated;
          unlockedOffer.unlockedOffer!.validatedAt = DateTime.now();
          break;
        }
      }

      emit(ActivateUnlockedOfferSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ActivateUnlockedOfferFailed(exception: alertException));
    }
  }
}
