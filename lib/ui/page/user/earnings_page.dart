import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/ui/page/user/transaction_page.dart';
import 'package:hoora/ui/widget/level_card.dart';
import 'package:hoora/ui/widget/user/unlocked_offer_card.dart';
import 'package:lottie/lottie.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(Init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + kPadding20),
                  buildTopbar(),
                  const Text("Mes gains", style: kBoldARPDisplay18),
                  const SizedBox(height: kPadding40),

                  /// Experience
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 115,
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(kRadius10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.read<UserBloc>().user.gem.toString(),
                                    style: kBoldARPDisplay25.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: kPadding5),
                                  Text(
                                    "Diamz sont actuellement dans votre cagnotte",
                                    style: kRegularNunito16.copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            Lottie.asset("assets/animations/gem.json", fit: BoxFit.cover),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: kPadding20),
                  const LevelCard(height: 115),
                  const SizedBox(height: kPadding20),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Mes offres disponibles",
                        style: kBoldNunito16,
                      )),
                  const SizedBox(height: kPadding20),

                  /// unlocked offers
                  ...buildUnlockedOffers(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> buildUnlockedOffers() {
    List<Widget> children = [];

    for (int index = 0; index < context.read<UserBloc>().unlockedOffers.length; index++) {
      Offer unlockedOffer = context.read<UserBloc>().unlockedOffers[index];
      EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 10);

      children.add(Padding(
        padding: padding,
        child: UnlockedOfferCard(offer: unlockedOffer),
      ));
    }

    return children;
  }

  Widget buildTopbar() {
    return Row(
      children: [
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
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home/earnings/settings");
            },
            icon: const Icon(
              Icons.settings_outlined,
              size: 32,
              color: kPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
