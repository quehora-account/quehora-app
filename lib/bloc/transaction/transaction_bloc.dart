import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/transaction_model.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;
  final CrashRepository crashRepository;

  late List<Transaction> transactions;

  TransactionBloc({
    required this.transactionRepository,
    required this.crashRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
  }

  void initialize(Init event, Emitter<TransactionState> emit) async {
    try {
      emit(InitLoading());
      transactions = await transactionRepository.getTransactions();
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
