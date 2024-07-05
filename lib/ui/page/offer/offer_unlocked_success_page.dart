import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/ui/page/user/earnings_page.dart';
import 'package:lottie/lottie.dart';

class OfferUnlockedSuccessPage extends StatelessWidget {
  final Offer offer;
  const OfferUnlockedSuccessPage({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
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

            /// Picture
            SizedBox(
              height: 100,
              width: double.infinity,
              child: getOfferImage(),
            ),

            /// title
            const SizedBox(height: kPadding40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding20),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Center(
                    child: Text(
                      "Merci pour\nvotre achat",
                      style: kBoldARPDisplay16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: kPadding20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding20),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Center(
                    child: Text(
                      "Votre commande est confirmée, votre coupon est disponible dès maintenant dans votre page cagnotte.",
                      style: kRegularNunito14,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: kPadding20),

            offer.codeType == CodeType.single_use
                ? Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: kPadding40),
                        child: LottieBuilder.asset(
                          "assets/animations/single_use.json",
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: LottieBuilder.asset(
                        "assets/animations/reference.json",
                      ),
                    ),
                  ),

            const SizedBox(height: kPadding20),

            offer.codeType == CodeType.single_use
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Votre code: ",
                          style: kRegularNunito16,
                        ),
                        Text(
                          offer.unlockedOffer!.code,
                          style: kBoldNunito16,
                        ),
                      ],
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPadding20),
                    child: Center(
                      child: Text(
                        "Validez votre coupon, sur place, le\njour de votre visite, uniquement en\nprésence du partenaire",
                        style: kBoldNunito14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

            const SizedBox(height: kPadding20),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding20),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: kButtonRoundedStyle,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const EarningsPage(),
                        ),
                        ModalRoute.withName('/home'));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ma cagnotte",
                        style: kBoldNunito16.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: kPadding20),
          ],
        ),
      ),
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
}
