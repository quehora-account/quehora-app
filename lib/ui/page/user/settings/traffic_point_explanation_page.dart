import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class TrafficPointExplanationPage extends StatelessWidget {
  const TrafficPointExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// back button
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
                const Center(
                    child: Text(
                  "Calcul des Diamz",
                  style: kBoldARPDisplay14,
                )),
                const SizedBox(height: kPadding40),
                const Text(
                  "Quehora valorise les visites en heures creuses pour réduire la congestion dans les lieux touristiques et favoriser une expérience de visite optimale. Découvrez le fonctionnement de notre système de Diamz :",
                  style: kRegularNunito14,
                ),
                buildSection(
                  "1. Sélection du moment et du lieu de votre visite",
                  "En choisissant de visiter pendant les heures creuses, vous gagnez des Diamz. Ces moments de faible affluence permettent une visite plus sereine et agréable, loin des foules."
                ),
                buildSection("2. Attribution des Diamz en fonction de l'impact",
                  "Les Diamz sont attribués selon votre impact sur la réduction de la fréquentation. Pour cela, nous comparons le nombre de visiteurs attendus lors de votre visite à la moyenne hebdomadaire. Plus l'affluence prévue pour votre créneau est inférieure à cette moyenne, plus vous gagnez de Diamz. Autrement dit, moins il y a de monde, plus vous accumulez de Diamz.\n\nQuehora utilise des données prévisionnelles d'affluence heure par heure provenant de sources fiables pour chaque site touristique, garantissant un calcul précis et pertinent."
                ),

                const SizedBox(height: kPadding40),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Image.asset("assets/images/graph_gem.png"),
                  ),
                ),

                buildSection("3. Exemple concret",
                    "En décalant votre visite du musée du Louvre du samedi après-midi au lundi matin, vous contribuez à réduire l'affluence du week-end. Cette démarche vous permet d'alléger les pics de fréquentation et, en retour, d’obtenir davantage de Diamz."),

                buildSection("4. Importance de votre choix",
                  "Opter pour les heures creuses ne profite pas seulement à votre expérience ; cela aide aussi à préserver les sites touristiques. En diminuant l’usure des lieux et le besoin de restaurations coûteuses, votre visite contribue à un tourisme plus durable, garantissant la préservation des sites pour les générations futures."
                ),

                buildSection("5. Utilisation de vos Diamz",
                  "Les Diamz que vous cumulez peuvent être échangés contre des avantages exclusifs auprès de nos partenaires, tels que des réductions ou des accès privilégiés, rendant ainsi votre expérience touristique encore plus enrichissante."
                ),

                const SizedBox(height: kPadding20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: kPadding40),
        Text(
          title,
          style: kBoldNunito14,
        ),
        const SizedBox(height: kPadding20),
        Text(
          content,
          style: kRegularNunito14,
        ),
      ],
    );
  }
}
