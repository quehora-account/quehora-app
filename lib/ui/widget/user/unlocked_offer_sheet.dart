import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/model/unlocked_offer_model.dart';
import 'package:hoora/ui/page/offer/offer_page.dart';
import 'package:slider_button/slider_button.dart';

class UnlockedOfferSheet extends StatelessWidget {
  final Offer offer;

  const UnlockedOfferSheet({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: kPrimary3,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(kRadius20),
              topRight: Radius.circular(kRadius20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 35,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: kPrimary,
                          width: 1,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => OfferPage(
                              offer: offer,
                              viewOnly: true,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Détail",
                        style: kRegularNunito14,
                      ),
                    ),
                  ),
                ),

                /// Picture
                SizedBox(
                  height: 40,
                  width: 40,
                  child: getCompanyImage(),
                ),

                const SizedBox(height: kPadding10),

                /// Name
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Text(
                    offer.company!.name,
                    style: kBoldARPDisplay14,
                    textAlign: TextAlign.center,
                  ),
                ),

                Builder(builder: (_) {
                  /// Single use
                  if (offer.codeType == CodeType.single_use) {
                    return Padding(
                      padding: const EdgeInsets.only(top: kPadding10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kPadding20, vertical: kPadding10),
                        child: Text(
                          'Mon code: ${offer.unlockedOffer!.code}',
                          style: kRegularNunito14,
                        ),
                      ),
                    );
                  }

                  /// Reference (2 states)
                  if (offer.unlockedOffer!.status == UnlockedOfferStatus.unlocked) {
                    return Column(
                      children: [
                        const SizedBox(height: kPadding5),
                        Text(
                          "Référence: ${offer.unlockedOffer!.code}",
                          style: kRegularNunito14,
                        ),
                        const SizedBox(height: kPadding10),

                        /// Slider
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: SizedBox(
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kPrimary, width: 2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: state is ActivateUnlockedOfferLoading
                                  ? const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: kPrimary,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(2.5),
                                      child: LayoutBuilder(builder: (_, constraint) {
                                        /// 25 the half of the button size with his padding (55/50 total)
                                        return SliderButton(
                                          width: constraint.maxWidth + 25,
                                          backgroundColor: Colors.transparent,
                                          alignLabel: const Alignment(0, 0),
                                          shimmer: false,
                                          vibrationFlag: false,
                                          action: () async {
                                            context.read<UserBloc>().add(ActivateUnlockedOffer(offer: offer));
                                            return false;
                                          },
                                          label: const Padding(
                                            /// 35 the button size
                                            padding: EdgeInsets.only(left: 35),
                                            child: Text(
                                              "J'utilise mon offre",
                                              style: kBoldNunito16,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                color: kPrimary,
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              child: const Icon(
                                                CupertinoIcons.arrow_right,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: kPadding10),

                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: kRegularNunito14,
                            children: [
                              TextSpan(
                                text: "Attention ! ",
                                style: kBoldNunito14,
                              ),
                              TextSpan(
                                text:
                                    "Assurez vous de ne confirmer qu'une\nfois que vous êtes chez le partenaire en lui\nmontrant la validation.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      const SizedBox(height: kPadding5),
                      Text(
                        "Référence: ${offer.unlockedOffer!.code}",
                        style: kRegularNunito14,
                      ),
                      const SizedBox(height: kPadding20),
                      Text(
                        "Vous avez utilisé cette offre\nle ${getDate()} à ${getHour()}",
                        style: kRegularNunito14,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }),
                SizedBox(height: MediaQuery.of(context).padding.bottom + kPadding20),
              ],
            ),
          ),
        );
      },
    );
  }

  String getDate() {
    DateTime validatedAt = offer.unlockedOffer!.validatedAt!;
    return "${validatedAt.day}/${validatedAt.month}/${validatedAt.year}";
  }

  String getHour() {
    DateTime validatedAt = offer.unlockedOffer!.validatedAt!;
    return "${validatedAt.hour}h${validatedAt.minute}";
  }

  Widget getCompanyImage() {
    return FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("company/${offer.company!.imagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: snapshot.data!,
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const SizedBox(),
            );
          }
          return const SizedBox();
        });
  }
}
