import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/bloc/challenge/challenge_bloc.dart' as challenge_bloc;
import 'package:hoora/bloc/explore/explore_bloc.dart' as explore_bloc;
import 'package:hoora/bloc/first_launch/first_launch_bloc.dart'
    as first_launch_bloc;
import 'package:hoora/bloc/map/map_bloc.dart' as map_bloc;
import 'package:hoora/bloc/offer/offer_bloc.dart' as offer_bloc;
import 'package:hoora/bloc/project/project_bloc.dart' as project_bloc;
import 'package:hoora/bloc/ranking/ranking_bloc.dart' as ranking_bloc;
import 'package:hoora/bloc/user/user_bloc.dart' as user_bloc;
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/challenge_page.dart';
import 'package:hoora/ui/page/explore/explore_page.dart';
import 'package:hoora/ui/page/gift_page.dart';
import 'package:hoora/ui/page/map/map_page.dart';
import 'package:hoora/ui/page/ranking_page.dart';
import 'package:hoora/ui/widget/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    context.read<user_bloc.UserBloc>().add(user_bloc.Init());
    context.read<explore_bloc.ExploreBloc>().add(explore_bloc.Init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    child: const ExplorePage(),
                  ),
                  const GiftPage(),
                  const MapPage(),
                  const ChallengePage(),
                  const RankingPage(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Navigation(
                onChanged: (page) async {
                  try {
                    await FirebaseAuth.instance.currentUser!.reload();
                  } catch (e) {
                    setState(() {
                      context.read<AuthBloc>().add(SignOut());
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/auth/sign_up",
                        (route) => false,
                      );
                    });
                  }

                  setState(() {
                    context.read<user_bloc.UserBloc>().add(user_bloc.Init());
                    if (page == 1) context.read<offer_bloc.OfferBloc>().add(offer_bloc.Init());
                    if (page == 1) context.read<project_bloc.ProjectBloc>().add(project_bloc.Init());
                    if (page == 2) {
                      context.read<map_bloc.MapBloc>().add(map_bloc.Init());
                    }
                    if (page == 2) {
                      context
                          .read<first_launch_bloc.FirstLaunchBloc>()
                          .add(first_launch_bloc.RequestGeolocation());
                    }
                    if (page == 3) context.read<challenge_bloc.ChallengeBloc>().add(challenge_bloc.Init());
                    if (page == 4) context.read<ranking_bloc.RankingBloc>().add(ranking_bloc.Init());
                    controller.jumpToPage(page);
                    SystemChrome.setSystemUIOverlayStyle(page == 2 ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
                    


                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
