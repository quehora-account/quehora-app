import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

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
                  "F.A.Q",
                  style: kBoldARPDisplay14,
                )),
                buildSection(
                  "Qu'est-ce que QUEHORA ?",
                  "QUEHORA est une application de tourisme durable qui utilise des données d'affluence pour encourager les visites pendant les heures creuses. En optimisant les horaires de visite, QUEHORA aide à réduire la congestion sur les sites touristiques, améliorer l'expérience des visiteurs et contribuer à la préservation du patrimoine culturel et naturel.",
                ),
                buildSection("Comment puis-je créer un compte sur QUEHORA ?",
                    "Pour accéder à QUEHORA, téléchargez l'application et créez un compte en utilisant une adresse e-mail valide et un mot de passe. Ce processus sécurise votre accès et personnalise votre expérience."),
                buildSection("L'application est-elle gratuite ?",
                    "Oui, QUEHORA est totalement gratuite. Les utilisateurs peuvent gagner des Diamz et les utiliser pour obtenir des avantages exclusifs chez nos partenaires sans frais supplémentaires."),

                buildSection("J'ai oublié mon mot de passe. Comment puis-je le récupérer ?",
                    "Si vous avez oublié votre mot de passe, cliquez sur le bouton \"J'ai oublié mon mot de passe\" lors de la connexion. Suivez les étapes pour récupérer ou modifier votre mot de passe en toute sécurité."),

                buildSection(
                    "Comment fonctionne le système de Diamz sur QUEHORA ?",
                    "QUEHORA utilise un système de Diamz pour récompenser les visites pendant les heures creuses. Plus vous visitez pendant ces périodes, plus vous gagnez de Diamz, que vous pouvez ensuite échanger contre des récompenses et des avantages exclusifs."),

                buildSection(
                    "Comment puis-je valider ma visite et gagner des Diamz ?",
                    "Pour valider une visite, sélectionnez le lieu sur la carte de l'application et assurez-vous d'être sur place pendant une heure creuse. Vous devrez autoriser QUEHORA à accéder à votre géolocalisation pour confirmer votre présence. Une fois la visite validée, les Diamz seront ajoutés à votre profil."),

                buildSection("Comment puis-je utiliser mes Diamz ?",
                    "Les Diamz accumulés peuvent être dépensés pour profiter d'avantages exclusifs chez nos partenaires. Consultez la page des récompenses sur l'application pour découvrir les offres et promotions disponibles."),
                buildSection("Comment puis-je contacter le support de QUEHORA ?",
                    "Pour nous contacter, envoyez-nous un e-mail directement ou écrivez-nous sur notre compte Instagram support@quehora.app. Nous sommes toujours à l'écoute de vos commentaires et prêts à vous aider."),

                buildSection("L'application est-elle disponible sur iOS et Android ?",
                    "Oui, QUEHORA est disponible à la fois sur iOS et Android, vous permettant d'accéder à nos services peu importe votre appareil."),

                buildSection("Comment QUEHORA garantit-elle la sécurité et la confidentialité de mes données ?",
                    "Nous prenons la sécurité et la confidentialité des données très au sérieux. QUEHORA collecte des données personnelles conformément aux lois en vigueur, notamment la géolocalisation, à des fins d'analyse et d'amélioration de l'application. Nous avons mis en place des mesures rigoureuses pour garantir la protection de vos données."),

                buildSection(
                    "Que se passe-t-il si je ne suis pas en mesure de valider ma visite en raison d'un problème de géolocalisation ?",
                    "Si vous rencontrez des problèmes de géolocalisation, assurez-vous que les services de localisation sont activés sur votre appareil et que QUEHORA a les permissions nécessaires. Si le problème persiste, contactez notre support pour obtenir de l'aide."),

                buildSection("Que se passe-t-il si l'objectif de don est atteint pour une association ?",
                    "Une fois l'objectif de don atteint, les utilisateurs ne peuvent plus faire de dons supplémentaires pour cette action spécifique. Vous serez informé lorsque l'objectif est atteint et invité à choisir une autre action à soutenir."),

                buildSection(
                    "Comment puis-je suggérer un nouveau site touristique ou une nouvelle action écologique à ajouter à QUEHORA ?",
                    "Vous pouvez nous envoyer vos suggestions via notre formulaire de contact sur notre site quehora.app ou à support@quehora.app. Nous étudierons toutes les propositions et envisagerons leur ajout dans une future mise à jour."),

                buildSection(
                    "Comment puis-je mettre à jour mes informations personnelles ou mes préférences de compte ?",
                    "Vous pouvez mettre à jour vos informations personnelles et vos préférences de compte dans les paramètres de l'application. Accédez à votre profil et modifiez les informations souhaitées."),
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
