import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/project_model.dart';
import 'package:hoora/ui/widget/gem_progress_bar.dart';

class ThanksForDonationPage extends StatelessWidget {
  final Project project;
  const ThanksForDonationPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: kPadding20),

            /// Back button
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
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: getProjectImage(),
              ),
            ),

            const SizedBox(height: kPadding40),
            const SizedBox(height: kPadding40),

            const Text(
              "Merci pour votre\ncontribution",
              style: kBoldARPDisplay18,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kPadding20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding20),
              child: FractionallySizedBox(
                  widthFactor: 0.7, child: GemProgressBar(value: project.collected, goal: project.goal)),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProjectImage() {
    return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref().child("project/${project.imagePath}").getDownloadURL(),
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
