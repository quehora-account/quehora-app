import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/user_model.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/user_repository.dart';

part 'ranking_event.dart';
part 'ranking_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  final UserRepository userRepository;
  final CrashRepository crashRepository;

  late List<User> users;
  late User user;
  late int userPosition;

  RankingBloc({
    required this.userRepository,
    required this.crashRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
  }

  void initialize(Init event, Emitter<RankingState> emit) async {
    try {
      emit(InitLoading());
      user = await userRepository.getUser();
      users = await userRepository.getAllUsers();
      users.sort((a, b) {
        return b.experience.compareTo(a.experience);
      });

      for (int i = 0; i < users.length; i++) {
        if (user.userId == users[i].userId) {
          userPosition = i;
          break;
        }
      }

      users = users.take(50).toList();
      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }
}
