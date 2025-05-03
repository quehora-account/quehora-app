import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:lottie/lottie.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackGreen,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(kPadding20,0,kPadding20,0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: kPadding20),
              Container(
                margin: const EdgeInsets.only(top: kPadding20),
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                    icon:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: Colors.white,height: 22,width: 22,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: Column(
                  children: [
                    const SizedBox(height: kPadding20),
                    Text(
                      "Bienvenue sur\nQuehora !",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding20),
                    contentText("Prêt à découvrir les meilleurs spots touristiques tout en gagnant des Diamz ? Quehora est là pour rendre vos visites plus pratiques et durables !",),
                    const SizedBox(height: kPadding60),
                    Text(
                      "Notre Philosophie",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                      child: Text(
                        "Visitez pendant les périodes de faible affluence pour équilibrer les flux de visiteurs et profiter d'une expérience plus agréable. En choisissant ces moments calmes, vous contribuez à réduire l'usure des sites et à diminuer l'impact environnemental, tout en étant récompensé par des Diamz pour votre action. Moins de monde = plus de Diamz !",
                        textAlign: TextAlign.center,
                        style: kRegularNunito16.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: kPadding60),
                    Text(
                      "Heures creuses ou pleines ?",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding20),
                    Padding(
                      padding: const EdgeInsets.all(kPadding20),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xffA0E2BF),
                                border: Border.all(color: Colors.white),
                                shape: BoxShape.circle
                            ),
                          ),
                          const SizedBox(height: kPadding20),
                          Text(
                          "Feu vert !",
                            textAlign: TextAlign.center,
                            style: kBoldNunito16.copyWith(color: Colors.white),
                          ),
                          Text(
                            "En heures creuses, c'est le moment idéal pour valider votre visite et récupérer des Diamz. Profitez-en !"
                            ,textAlign: TextAlign.center,
                            style: kRegularNunito16.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kPadding20),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xffE8AEBF),
                                border: Border.all(color: Colors.white),
                                shape: BoxShape.circle
                            ),
                          ),
                          const SizedBox(height: kPadding20),
                          Text(
                            "Feu rouge !",
                            textAlign: TextAlign.center,
                            style: kBoldNunito16.copyWith(color: Colors.white),
                          ),
                          Text(
                            "Beaucoup de monde en ce moment. Reportez votre visite si possible. Si vous êtes sur place, partagez l'affluence et gagnez des Diamz en aidant les autres visiteurs.",
                            textAlign: TextAlign.center,
                            style: kRegularNunito16.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kPadding20),

                    const SizedBox(height: kPadding40),
                    Text(
                      "Comment gagner\ndes Diamz ?",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0), // Set border radius here
                          child: Lottie.asset(
                            "assets/animations/map.json",
                            fit: BoxFit.cover, // To ensure the animation fits within the bounds
                          ),
                        ),
                      ),
                    ),
                    buildSection(
                      "1. Validez votre visite !\n",
                      'Rendez-vous physiquement dans le site touristique de votre choix pendant une heure creuse. Sélectionnez le bouton central dans le menu et faites glisser le curseur "Je valide ma visite !" Votre position GPS est détectée, et vous remportez les Diamz affichés !'
                    ),
                    buildSection("2. Partagez l'affluence !\n",
                      "Vous pouvez également partager l'affluence ou signaler un temps d'attente. Vous gagnerez des Diamz pour cette contribution, en heures creuses ou en heures pleines."
                    ),
                    const SizedBox(height: kPadding40),
                    Text(
                      "Types de Lieux",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding20),
                    contentText("Les différents spots touristiques sont répartis par catégories afin de faciliter leur identification sur la carte.",),
                    const SizedBox(height: kPadding20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(kPadding10),
                                  child: SvgPicture.asset("assets/svg/Attractions.svg",height: 24,color: Colors.white,),
                                ),
                                Text("Attraction\ntouristique",textAlign:TextAlign.center,style: kRegularNunito12.copyWith(color: Colors.white),)
                              ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(kPadding10),
                                child: SvgPicture.asset("assets/svg/Lieuxdinterets.svg",height: 24,color: Colors.white,),
                              ),
                              Text("Point\nd’intéret",textAlign:TextAlign.center,style: kRegularNunito12.copyWith(color: Colors.white),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(kPadding10),
                                child: SvgPicture.asset("assets/svg/Natural.svg",height: 24,color: Colors.white,),
                              ),
                              Text("Lieu\nnaturel",textAlign:TextAlign.center,style: kRegularNunito12.copyWith(color: Colors.white),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(kPadding10),
                                child: SvgPicture.asset("assets/svg/Musees.svg",height: 24,color: Colors.white,),
                              ),
                              Text("Edifice\nà visiter",textAlign:TextAlign.center,style: kRegularNunito12.copyWith(color: Colors.white),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kPadding60),
                    Text(
                      "Signalements",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding40),
                    Image.asset("assets/images/villa.png"),
                    const SizedBox(height: kPadding20),
                    contentText("Consultez en temps réel les signalements des autres utilisateurs pour éviter les foules et les temps d’attente. Sur place, gagnez des Diams en signalant à votre tour l’affluence aux autres voyageurs.",),
                    const SizedBox(height: kPadding60),
                    Text(
                      "Comment sont\ncalculés vos Diamz ?",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding20),
                    contentText("Vos Diamz sont attribués selon notre algorithme intelligent de sorte à récompenser d’avantage les visites pendant les heures les moins fréquentées du spot touristique. ")
                    ,const SizedBox(height: kPadding60),
                    Text(
                      "Echanger vos  Diamz",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding20),
                    contentText("Échangez vos Diamz pour obtenir des récompenses ou soutenir des associations locales et environnementales",),
                    const SizedBox(height: kPadding60),
                    Text(
                      "Besoin d’aide ?",
                      textAlign: TextAlign.center,
                      style: kBoldARPDisplay18.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kPadding20),
                    contentText("Des questions ou des soucis ? Écrivez-nous à hello@quehora.app ou contactez-nous sur Instagram  @quehora.app.",),
                    const SizedBox(height: kPadding40),
                    const SizedBox(height: kPadding40),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: title,
                  style: kBoldNunito16.copyWith(color: Colors.white)),
              TextSpan(
                  text: " $content",
                  style: kRegularNunito16.copyWith(color: Colors.white)),
            ]),),
          const SizedBox(height: kPadding30),
        ],
      ),
    );
  }
  Widget contentText(String text) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding15),
      child:Text(
      text,
      textAlign: TextAlign.center,
      style: kRegularNunito16.copyWith(color: Colors.white),
    ));
  }
}
