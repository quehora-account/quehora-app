import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/level_model.dart';

class LevelCard extends StatelessWidget {
  final double height;
  const LevelCard({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = context.read<UserBloc>();
    Level level = Level.getLevel(userBloc.user.level);

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/home/earnings/level");
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: kSecondary,
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
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mon niveau",
                          style: kRegularNunito14,
                        ),
                        const SizedBox(height: kPadding5),
                        Text(
                          level.title,
                          style: kBoldARPDisplay16,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  getLevelSvg(level)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getLevelSvg(Level level) {
    return SizedBox(
      width: 60,
      child: FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("level/${level.imagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return SvgPicture.network(
              snapshot.data!,
              height: 60,
            );
          }
          return const SizedBox();
          }),
    );
  }
}
