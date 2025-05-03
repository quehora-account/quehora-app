import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
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
                    icon:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: kPrimary,height: 22,width: 22,),
                ),
              ),
              const Center(
                  child: Text(
                "Confidentialité",
                style: kBoldARPDisplay14,
              )),
              const SizedBox(height: kPadding40),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  // Uri url = Uri.parse('https://hello@quehora.app');
                  //
                  // if (!await launchUrl(url)) {
                  //   throw Exception('Could not launch $url');
                  // }
                },
                child: const Text(
                  "Support & Aide\nhello@quehora.app",
                  style: kRegularNunito16,
                ),
              ),
              const SizedBox(height: kPadding20,),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  // Uri url = Uri.parse(
                  //     'https://rain-appeal-1ed.notion.site/Conditions-G-n-rales-d-Utilisation-de-QUEHORA-8fdde97d85c249f8aaa63d30e19ea247');
                  //
                  // if (!await launchUrl(url)) {
                  //   throw Exception('Could not launch $url');
                  // }
                },
                child: const Text(
                  "Conditions Générales d'Utilisation (CGU)\nhttps://www.notion.so/Conditions-G-n-rales-d-Utilisation-de-QUEHORA-8fdde97d85c249f8aaa63d30e19ea247",
                  style: kRegularNunito16,
                ),
              ),
              const SizedBox(height: kPadding20,),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  // Uri url = Uri.parse(
                  //     'https://rain-appeal-1ed.notion.site/Politique-de-Confidentialit-de-QUEHORA-c0d152c43773428e8e350e08514e0a0e');
                  //
                  // if (!await launchUrl(url)) {
                  //   throw Exception('Could not launch $url');
                  // }
                },
                child: const Text(
                  "Politique de Confidentialité de Quehora\nhttps://www.notion.so/Politique-de-Confidentialit-de-QUEHORA-c0d152c43773428e8e350e08514e0a0e?pvs=13",
                  style: kRegularNunito16,
                ),
              ),
              const SizedBox(height: kPadding20,),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  // Uri url = Uri.parse(
                  //     'https://rain-appeal-1ed.notion.site/Mentions-l-gales-2d93c03ec6664682af0db923d4320994');
                  //
                  // if (!await launchUrl(url)) {
                  //   throw Exception('Could not launch $url');
                  // }
                },
                child: const Text(
                  "Mentions légales\nhttps://www.notion.so/Mentions-l-gales-2d93c03ec6664682af0db923d4320994",
                  style: kRegularNunito16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
