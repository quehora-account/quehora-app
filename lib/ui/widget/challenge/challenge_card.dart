import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/challenge/challenge_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/challenge_model.dart';
import 'package:hoora/model/unlocked_challenge_model.dart';

class ChallengeCard extends StatefulWidget {
  final Challenge challenge;
  const ChallengeCard({super.key, required this.challenge});

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  bool hasUnlockedChallenge = false;
  late UnlockedChallenge unlockedChallenge;
  late ChallengeBloc challengeBloc;

  @override
  void initState() {
    super.initState();

    challengeBloc = context.read<ChallengeBloc>();

    if (widget.challenge.unlockedChallenge != null) {
      hasUnlockedChallenge = true;
      unlockedChallenge = widget.challenge.unlockedChallenge!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengeBloc, ChallengeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (hasUnlockedChallenge &&
                unlockedChallenge.status == ChallengeStatus.unlocked &&
                state is! ClaimLoading) {
              challengeBloc.add(ClaimChallenge(challenge: widget.challenge));
            }
          },
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: widget.challenge.getBackgroundColor(),
              borderRadius: BorderRadius.circular(kRadius10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kPadding10),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: kBackground,
                      borderRadius: BorderRadius.circular(kRadius10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(kPadding10),
                      child: getImage(),
                    ),
                  ),
                  const SizedBox(width: kPadding10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: kPadding5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.challenge.name,
                            style: kBoldARPDisplay12.copyWith(color: widget.challenge.getTextColor()),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(height: kPadding5),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.challenge.description,
                                      style: kRegularNunito12.copyWith(
                                        color: widget.challenge.getTextColor(),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: kPadding5),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: buildStatusContainer(state),
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
          ),
        );
      },
    );
  }

  Widget getImage() {
    return FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("challenge/${widget.challenge.imagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: snapshot.data!,
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const SizedBox(),
            );
          }
          return const SizedBox();
        });
  }

  Widget buildStatusContainer(ChallengeState state) {
    /// User can claim his reward
    if (hasUnlockedChallenge && unlockedChallenge.status == ChallengeStatus.unlocked) {
      return Container(
        height: 30,
        width: 70,
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.circular(kRadius100),
        ),
        child: state is ClaimLoading && widget.challenge.id == state.challengeId
            ? const Center(
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: kBackground,
                  ),
                ),
              )
            : Center(
                child: Text(
                  "Collecter",
                  style: kBoldNunito12.copyWith(color: Colors.white),
                ),
              ),
      );
    }

    /// Claimed
    if (hasUnlockedChallenge && unlockedChallenge.status == ChallengeStatus.claimed) {
      return Container(
        height: 30,
        width: 70,
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.circular(kRadius100),
        ),
        child: state is ClaimLoading && state.challengeId == widget.challenge.id
            ? const Center(
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: kBackground,
                  ),
                ),
              )
            : Center(
                child: Text(
                  "Terminé",
                  style: kBoldNunito12.copyWith(color: Colors.white),
                ),
              ),
      );
    }

    return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
        color: kGemsIndicator,
        borderRadius: BorderRadius.circular(kRadius100),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 35,
            height: 30,
            child: Center(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.challenge.gem.toString(),
                  style: kBoldARPDisplay13,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            width: 35,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(right: kPadding5),
              child: SvgPicture.asset(
                "assets/svg/gem.svg",
                height: 15,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
