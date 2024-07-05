import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/offer/offer_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/ui/page/offer/offer_unlocked_success_page.dart';

class OfferPage extends StatelessWidget {
  final Offer offer;
  final bool viewOnly;
  const OfferPage({super.key, required this.offer, this.viewOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: kPadding20,
              ),

              /// back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: Align(
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
              ),

              /// Pictures
              SizedBox(
                height: 132.5,
                width: double.infinity,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: getOfferImage(),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: kPadding20),
                        child: Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                            color: kBackground,
                            borderRadius: BorderRadius.circular(kRadius100),
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
                            padding: const EdgeInsets.all(15),
                            child: getCompanyImage(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// title
              const SizedBox(height: kPadding10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Center(
                      child: Text(
                        offer.company!.name,
                        style: kBoldARPDisplay16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kPadding5),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Center(
                      child: Text(
                        offer.title,
                        style: kRegularNunito12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: kPadding20),

              /// Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding20),
                child: Text(
                  "Présentation de l'Offre :",
                  style: kBoldNunito12,
                ),
              ),
              const SizedBox(height: kPadding20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: Text(
                  offer.description,
                  style: kRegularNunito12,
                ),
              ),
              const SizedBox(height: kPadding20),

              /// instructions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding20),
                child: Text(
                  "Comment profiter de l'Offre :",
                  style: kBoldNunito12,
                ),
              ),
              const SizedBox(height: kPadding20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: buildInstructions(),
              ),

              const SizedBox(height: kPadding20),

              /// conditions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding20),
                child: Text(
                  "Conditions et validité",
                  style: kBoldNunito12,
                ),
              ),
              const SizedBox(height: kPadding20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: buildConditions(),
              ),
              const SizedBox(height: kPadding20),
              if (!viewOnly)
                Padding(
                  padding: const EdgeInsets.only(left: kPadding20, right: kPadding20, bottom: kPadding20),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: kButtonRoundedStyle,
                      onPressed: context.read<UserBloc>().user.gem >= offer.price
                          ? () {
                              showUnlockPopup(context);
                            }
                          : () {
                              Alert.showSuccess(context, "Vous n'avez pas assez de .");
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Convertir ${offer.price.toString()}",
                            style: kBoldNunito16.copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: kPadding5),
                          SvgPicture.asset("assets/svg/gem.svg"),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showUnlockPopup(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<OfferBloc, OfferState>(
          listener: (context, state) {
            if (state is UnlockSuccess) {
              context.read<UserBloc>().add(RemoveGem(gem: offer.price));

              /// Add the unlocked state
              offer.unlockedOffer = state.unlockedOffer;
              context.read<UserBloc>().add(AddUnlockedOffer(offer: offer));

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => OfferUnlockedSuccessPage(
                    offer: offer,
                  ),
                ),
                (route) => route.settings.name == "/home",
              );
            }
          },
          builder: (context, state) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(kPadding20),
              backgroundColor: kBackground,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Êtes-vous sûr(e) de vouloir échanger vos Diamz contre cette prestation ? Veuillez noter que cette action est définitive et ne peut être annulée.',
                    style: kRegularNunito14,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kPadding20),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is UnlockLoading
                          ? null
                          : () {
                              context.read<OfferBloc>().add(Unlock(offer: offer));
                            },
                      style: kButtonRoundedStyle,
                      child: state is UnlockLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Convertir ${offer.price.toString()}",
                                  style: kBoldNunito16.copyWith(color: Colors.white),
                                ),
                                const SizedBox(width: kPadding5),
                                SvgPicture.asset("assets/svg/gem.svg"),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Annuler",
                        style: kRegularNunito16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildInstructions() {
    List<Widget> children = [];

    for (String instruction in offer.instructions) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: kPadding10),
          child: Row(
            children: [
              const Icon(Icons.check),
              const SizedBox(width: kPadding10),
              Expanded(child: Text(instruction, style: kRegularNunito12)),
            ],
          ),
        ),
      );
    }
    return Column(
      children: children,
    );
  }

  Widget buildConditions() {
    List<Widget> children = [];

    // Obtenez les entrées de la map et triez-les par clé
    var sortedEntries = offer.conditions.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Parcourez les entrées triées pour construire les widgets
    for (var entry in sortedEntries) {
      String key = entry.key.substring(1);
      String value = entry.value;

      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: kPadding10),
          child: RichText(
            text: TextSpan(
              style: kRegularNunito12,
              children: [
                TextSpan(
                  text: "$key ",
                  style: kBoldNunito12,
                ),
                TextSpan(
                  text: value,
                ),
              ],
            ),
          ),
        ),
      );
    }
  
    return Column(
      children: children,
    );
  }

  Widget getOfferImage() {
    return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref().child("offer/${offer.imagePath}").getDownloadURL(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return CachedNetworkImage(
            fit: BoxFit.fitWidth,
            imageUrl: snapshot.data!,
            placeholder: (context, url) => const SizedBox(),
            errorWidget: (context, url, error) => const SizedBox(),
          );
        }
        return const SizedBox();
      },
    );
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
      },
    );
  }
}
