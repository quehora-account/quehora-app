import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/offer/offer_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/level_model.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/ui/widget/level_card.dart';
import 'package:hoora/ui/widget/offer/offer_card.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> with AutomaticKeepAliveClientMixin {
  late OfferBloc offerBloc;

  @override
  void initState() {
    super.initState();
    offerBloc = context.read<OfferBloc>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<OfferBloc, OfferState>(
      listener: (context, state) {
        if (state is InitFailed) {
          Alert.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding20),
                child: LevelCard(height: 100),
              ),
              const SizedBox(height: kPadding20),
              Builder(builder: (_) {
                List<Widget> children = [];

                for (int i = 0; i < offerBloc.categories.length; i++) {
                  List<Offer> offers = offerBloc.categories[i];
                  Level level = Level.getLevel(i + 1);

                  if (offers.isEmpty) {
                    continue;
                  }
                  children.add(
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: kPadding20),
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: getBlankLevelSvg(level),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Niveau ${level.displayedLevel}',
                              style: kRBoldNunito18,
                            ),
                          ],
                        ),
                        const SizedBox(height: kPadding10),
                        SizedBox(
                          /// 10 for the shadow to be displayed
                          height: 170 + 10,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: offers.length,
                            itemBuilder: (_, index) {
                              Offer offer = offers[index];
                              EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10);

                              if (index == 0) {
                                padding = const EdgeInsets.only(left: 20, right: 10);
                              }

                              if (index == offers.length - 1 && offers.length > 1) {
                                padding = const EdgeInsets.only(right: 20);
                              }

                              return Padding(
                                padding: padding,
                                child: Align(alignment: Alignment.topCenter, child: OfferCard(offer: offer)),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: kPadding20),
                      ],
                    ),
                  );
                }

                return Column(
                  children: children,
                );
              })
            ],
          ),
        );
      },
    );
  }

  Widget getBlankLevelSvg(Level level) {
    return FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("level/${level.blankImagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return SvgPicture.network(
              snapshot.data!,
            );
          }
          return const SizedBox();
        });
  }

  @override
  bool get wantKeepAlive => true;
}
