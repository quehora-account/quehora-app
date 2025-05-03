import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/challenge/challenge_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart' as user_bloc;
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/challenge_model.dart';
import 'package:hoora/ui/widget/challenge/challenge_card.dart';
import 'package:hoora/ui/widget/gem_button.dart';
import 'package:lottie/lottie.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late ChallengeBloc challengeBloc;
  late AnimationController controller;
  bool showAnimation = false;

  @override
  void initState() {
    super.initState();
    challengeBloc = context.read<ChallengeBloc>();
    controller = AnimationController(vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showAnimation = false;
        });
        controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
          if (state is InitFailed) {
            Alert.showError(context, state.exception.message);
          }

          if (state is ClaimSuccess) {
            /// Show animation
            setState(() {
              showAnimation = true;
            });

            /// Update user gems
            context.read<user_bloc.UserBloc>().add(user_bloc.AddGem(gem: state.gem));

            /// Display success message
            Alert.showSuccessWidget(
              context,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous avez gagné ${state.gem} Diamz !",
                    style: kBoldARPDisplay13.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: kPadding10),
                  SvgPicture.asset("assets/svg/gem.svg"),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is InitLoading || state is InitFailed) {
            return const Center(child: CircularProgressIndicator(color: kPrimary));
          }

          return Stack(
            children: [
              if (showAnimation)
                LottieBuilder.asset(
                  "assets/animations/confetis.json",
                  repeat: false,
                  controller: controller,
                  onLoaded: (composition) {
                    controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(kPadding20,kPadding20,kPadding20,kPadding40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Flexible(
                          child: Text(
                            "Relevez des défis\n& Gagnez plus de Diamz !",
                            style: kBoldARPDisplay18,
                          ),
                        ),
                        GemButton(isLight: true,bigGem: true,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: kPadding20),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/challenge_mountain.svg"),
                        const SizedBox(width: kPadding10),
                        const Text("Challenges", style: kRBoldNunito18),
                      ],
                    ),
                  ),
                  const SizedBox(height: kPadding10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                      child: ListView.builder(
                          itemCount: challengeBloc.challenges.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            Challenge challenge = challengeBloc.challenges[index];
                            EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 10);

                            if (index == 0) {
                              padding = const EdgeInsets.only(top: 10, bottom: 10);
                            }

                            if (index == challengeBloc.challenges.length - 1 && challengeBloc.challenges.length > 1) {
                              padding = const EdgeInsets.only(bottom: 20);
                            }

                            return Padding(
                              padding: padding,
                              child: ChallengeCard(key: UniqueKey(), challenge: challenge),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
