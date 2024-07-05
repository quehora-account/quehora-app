import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/transaction/transaction_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/transaction_model.dart';
import 'package:hoora/ui/widget/user/transaction_card.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late TransactionBloc transactionBloc;

  @override
  void initState() {
    super.initState();
    transactionBloc = context.read<TransactionBloc>();
    transactionBloc.add(Init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InitLoading || state is InitFailed) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimary,
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding20),
              child: Column(
                children: [
                  const SizedBox(height: kPadding20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_left,
                        size: 32,
                        color: kPrimary,
                      ),
                    ),
                  ),
                  const Text(
                    "Mes transactions",
                    style: kBoldARPDisplay18,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kPadding20),
                  Expanded(
                    child: ListView.builder(
                        itemCount: transactionBloc.transactions.length,
                        itemBuilder: (_, index) {
                          EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 15);
                          Transaction transaction = transactionBloc.transactions[index];

                          if (index == 0) {
                            padding = const EdgeInsets.only(top: 20, bottom: 15);
                          }

                          if (index == transactionBloc.transactions.length - 1 &&
                              transactionBloc.transactions.length > 1) {
                            padding = const EdgeInsets.only(bottom: 20);
                          }

                          return Padding(
                            padding: padding,
                            child: TransactionCard(transaction: transaction),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
