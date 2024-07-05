import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/project/project_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/project_model.dart';
import 'package:hoora/ui/page/project/thanks_for_donation_page.dart';
import 'package:hoora/ui/widget/gem_progress_bar.dart';

class ProjectPage extends StatelessWidget {
  final Project project;
  final bool canDonate;
  const ProjectPage({super.key, required this.project, this.canDonate = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kPadding20),

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
                      child: getProjectImage(),
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
                            child: getOrganizationImage(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: kPadding10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Text(
                          project.title,
                          style: kBoldARPDisplay16,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: kPadding10),

                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: GemProgressBar(
                          value: project.collected,
                          goal: project.goal,
                        ),
                      ),
                    ),

                    const SizedBox(height: kPadding5),
                    const Center(
                        child: Text("Diamz récoltés / Objectif",
                            style: kRegularNunito12)),
                    const SizedBox(height: kPadding20),

                    buildDescriptions(),
                    const SizedBox(height: kPadding20),

                    if (canDonate) buildDonationButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDescriptions() {
    List<Widget> children = [];

    // Obtenez les entrées de la map et triez-les par clé
    var sortedEntries = project.descriptions.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Parcourez les entrées triées pour construire les widgets
    for (var entry in sortedEntries) {
      String key = entry.key;
      String value = entry.value;

      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(key.substring(1), style: kBoldNunito12),
          const SizedBox(height: kPadding10),
          Text(value, style: kRegularNunito12),
          const SizedBox(height: kPadding20),
        ],
      ));
    }
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget buildDonationButtons(context) {
    return Column(
      children: [
        const Center(
          child: Text(
            "Soutenir l'association en effectuant un don",
            style: kBoldNunito12,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: kPadding10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (project.smallDonation > 0)
              ElevatedButton(
                style: kButtonRoundedStyle,
                onPressed: () {
                  showDonatePopup(context, project.smallDonation);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: kPadding10),
                  child: Row(
                    children: [
                      Text(
                        project.smallDonation.toString(),
                        style: kBoldARPDisplay12.copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        width: kPadding5,
                      ),
                      SvgPicture.asset("assets/svg/gem.svg"),
                    ],
                  ),
                ),
              ),
            if (project.mediumDonation > 0)
              ElevatedButton(
                style: kButtonRoundedStyle,
                onPressed: () {
                  showDonatePopup(context, project.mediumDonation);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: kPadding10),
                  child: Row(
                    children: [
                      Text(
                        project.mediumDonation.toString(),
                        style: kBoldARPDisplay12.copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        width: kPadding5,
                      ),
                      SvgPicture.asset("assets/svg/gem.svg"),
                    ],
                  ),
                ),
              ),
            if (project.bigDonation > 0)
              ElevatedButton(
                style: kButtonRoundedStyle,
                onPressed: () {
                  showDonatePopup(context, project.bigDonation);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: kPadding10),
                  child: Row(
                    children: [
                      Text(
                        project.bigDonation.toString(),
                        style: kBoldARPDisplay12.copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        width: kPadding5,
                      ),
                      SvgPicture.asset("assets/svg/gem.svg"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void showDonatePopup(context, int gem) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) {
            if (state is DonateSuccess) {
              context.read<UserBloc>().add(RemoveGem(gem: state.gem));

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ThanksForDonationPage(
                    project: project,
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
                      onPressed: state is DonateLoading
                          ? null
                          : () {
                              if (context.read<UserBloc>().user.gem < gem) {
                                Alert.showSuccess(context, "Vous n'avez pas assez de diamants.");
                              } else {
                                context.read<ProjectBloc>().add(Donate(project: project, gem: gem));
                              }
                            },
                      style: kButtonRoundedStyle,
                      child: state is DonateLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Convertir ${gem.toString()}",
                                  style: kBoldNunito16.copyWith(color: Colors.white),
                                ),
                                const SizedBox(
                                  width: kPadding5,
                                ),
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

  Widget getOrganizationImage() {
    return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref().child("organization/${project.organization!.imagePath}").getDownloadURL(),
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
