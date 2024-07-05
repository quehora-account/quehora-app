import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/project/project_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/donation_model.dart';
import 'package:hoora/model/project_model.dart';
import 'package:hoora/ui/page/project/project_page.dart';
import 'package:hoora/ui/widget/gem_progress_bar.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (project.collected < project.goal) {
          bool canDonate = true;
          List<Donation> donations = context.read<ProjectBloc>().donations;
          for (Donation donation in donations) {
            if (donation.projectId == project.id) {
              canDonate = false;
            }
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectPage(
                project: project,
                canDonate: canDonate,
              ),
            ),
          );
        }
      },
      child: Container(
        height: 160,
        width: getWidth(context),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(kRadius10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            /// Offer picture
            SizedBox(
              height: 100,
              width: getWidth(context),
              child: Stack(
                children: [
                  getProjectImage(),
                  // Progress bar
                  if (project.collected < project.goal)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding10),
                        child: FractionallySizedBox(
                          widthFactor: 0.65,
                          child: GemProgressBar(value: project.collected, goal: project.goal),
                        ),
                      ),
                    ),

                  if (project.collected >= project.goal)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding10),
                        child: Container(
                          height: 25,
                          width: 170,
                          decoration: BoxDecoration(
                            color: kBackground,
                            borderRadius: BorderRadius.circular(kRadius100),
                          ),
                          child: const Center(
                            child: Text(
                              "Projet financé",
                              style: kBoldARPDisplay12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Informations
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kPadding10),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: getOrganizationImage(),
                    ),
                    const SizedBox(width: kPadding10),
                    SizedBox(
                      width: getWidth(context) - (30 + 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.title,
                            style: kBoldARPDisplay14,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(height: kPadding5),
                          Text(
                            project.subtitle,
                            style: kRegularNunito14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getWidth(BuildContext context) {
    return (MediaQuery.of(context).size.width - 40);
  }

  Widget getProjectImage() {
    return FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("project/${project.imagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: snapshot.data!,
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const SizedBox(),
              imageBuilder: (context, imageProvider) => LayoutBuilder(builder: (_, constraint) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kRadius10),
                      topRight: Radius.circular(kRadius10),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            );
          }
          return const SizedBox();
        });
  }

  Widget getOrganizationImage() {
    return FutureBuilder<String>(
        future:
            FirebaseStorage.instance.ref().child("organization/${project.organization!.imagePath}").getDownloadURL(),
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
