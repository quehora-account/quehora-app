import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/ranking/ranking_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/user_model.dart';
import 'package:hoora/ui/widget/gem_button.dart';
import 'package:hoora/ui/widget/ranking/ranked_card.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with AutomaticKeepAliveClientMixin {
  late RankingBloc rankingBloc;

  @override
  void initState() {
    super.initState();
    rankingBloc = context.read<RankingBloc>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<RankingBloc, RankingState>(
        listener: (context, state) {
          if (state is InitFailed) {
            Alert.showError(context, state.exception.message);
          }
        },
        builder: (context, state) {
          if (state is InitLoading || state is InitFailed) {
            return const Center(child: CircularProgressIndicator(color: kPrimary));
          }

          return Column(
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
                        "Montez dans le  classement &\ngagnez des Diamz !",
                        style: kBoldARPDisplay18,
                      ),
                    ),
                    GemButton(isLight: true,bigGem: true,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/ranking_rugby.svg"),
                    const SizedBox(width: kPadding10),
                    const Text("Classement", style: kRBoldNunito18),
                  ],
                ),
              ),
              const SizedBox(height: kPadding5),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Vos diamz cumulés depuis le début",
                    style: kBalooPaaji12,
                  ),
                ),
              ),
              const SizedBox(height: kPadding10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                  child: ListView.builder(
                      itemCount: rankingBloc.users.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        User user = rankingBloc.users[index];
                        EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 10);

                        if (index == 0) {
                          padding = const EdgeInsets.only(top: 10, bottom: 10);
                        }

                        if (index == rankingBloc.users.length - 1 && rankingBloc.users.length > 1) {
                          padding = const EdgeInsets.only(bottom: 20);
                        }

                        return Padding(
                          padding: padding,
                          child: RankedCard(
                            user: user,
                            position: index + 1,
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kPadding20),
                child: RankedCard(
                  user: rankingBloc.user,
                  position: rankingBloc.userPosition + 1,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
