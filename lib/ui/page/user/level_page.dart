import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/level_model.dart';
import 'package:hoora/ui/widget/gem_progress_bar.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  late UserBloc userBloc;
  late Level level;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    level = Level.getLevel(userBloc.user.level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + kPadding20),
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
              const Text(
                "Votre impact positif\nest récompensé !",
                style: kBoldARPDisplay18,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: kPadding40),
              SizedBox(height: 50, child: getLevelSvg(level)),
              const SizedBox(height: kPadding5),
              const Text(
                "Mon niveau",
                style: kRegularNunito14,
              ),
              const SizedBox(height: kPadding5),
              Text(
                level.title,
                style: kBoldARPDisplay11,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: kPadding40),
              if (userBloc.user.level < Level.levels.last.level)
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Row(
                    children: [
                      Text(
                        level.displayedLevel,
                        style: kBoldARPDisplay11,
                      ),
                      const SizedBox(width: kPadding10),
                      Expanded(
                        child: GemProgressBar(
                          value: userBloc.user.experience,
                          goal: level.getNextLevel()!.experienceRequired,
                        ),
                      ),
                      const SizedBox(width: kPadding10),
                      Text(
                        level.getNextLevel()!.displayedLevel,
                        style: kBoldARPDisplay11,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: kPadding40),
              const FractionallySizedBox(
                widthFactor: 0.8,
                child: Text(
                  "Tous vos gains depuis votre inscription sont comptabilisés et vous permettent de monter en niveau. Cumulez encore plus de Diamz pour débloquer des récompenses toujours plus alléchantes !",
                  textAlign: TextAlign.center,
                  style: kRegularNunito14,
                ),
              ),
              const SizedBox(height: kPadding20),
              const FractionallySizedBox(
                widthFactor: 0.8,
                child: Text(
                  "Plus vous visitez durablement, plus vous êtes récompensés !",
                  textAlign: TextAlign.center,
                  style: kBoldNunito14,
                ),
              ),
              const SizedBox(height: kPadding40),
              buildLevels(),
              SizedBox(height: MediaQuery.of(context).padding.bottom + kPadding20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLevels() {
    List<Widget> children = [];

    for (Level level in Level.levels) {
      children.add(
        SizedBox(
          width: 100,
          height: 100,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: getLevelSvg(level),
              ),
              const SizedBox(height: kPadding5),
              Text(
                "Niveau ${level.displayedLevel}",
                style: kBoldNunito14,
              ),
              const SizedBox(height: kPadding5),
              Text(
                level.title,
                textAlign: TextAlign.center,
                style: kBoldNunito12,
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 20,
      children: children,
    );
  }

  Widget getLevelSvg(Level level) {
    return FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("level/${level.imagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return SvgPicture.network(
              snapshot.data!,
            );
          }
          return const SizedBox();
        });
  }
}
