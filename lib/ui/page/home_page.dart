import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/bloc/challenge/challenge_bloc.dart' as challenge_bloc;
import 'package:hoora/bloc/explore/explore_bloc.dart' as explore_bloc;
import 'package:hoora/bloc/offer/offer_bloc.dart' as offer_bloc;
import 'package:hoora/bloc/project/project_bloc.dart' as project_bloc;
import 'package:hoora/bloc/ranking/ranking_bloc.dart' as ranking_bloc;
import 'package:hoora/bloc/user/user_bloc.dart' as user_bloc;
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/challenge_page.dart';
import 'package:hoora/ui/page/explore/explore_page.dart';
import 'package:hoora/ui/page/gift_page.dart';
import 'package:hoora/ui/page/ranking_page.dart';
import 'package:hoora/ui/widget/navigation_bar.dart';
import '../../common/globals.dart';
import 'explore/validation_loading.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  PageController controller = PageController(initialPage: 0);
  bool _isExplorePage = false;
  @override
  void initState() {
    super.initState();
    context.read<user_bloc.UserBloc>().add(user_bloc.Init());
    context.read<explore_bloc.ExploreBloc>().add(explore_bloc.Init());

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300), // duration of animation
      vsync: this,
    );

    // Set the slide-down animation
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // starts in its position
      end:Offset.zero , // slides down
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground2,
      resizeToAvoidBottomInset: false,
      body: Padding (
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Stack(
          children: [
            Padding(
              padding:  EdgeInsets.only(bottom: _isExplorePage?0:60),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    child:  ExplorePage(
                      key:AppConstants.explorePageKey,
                      changeBottomNavDisplay: (show) {
                      setState(() {
                        _isExplorePage = show;
                      });
                      if (show) {
                        _controller.reverse(); // Show the navigation by sliding it back up
                      } else {
                        _controller.forward(); // Hide the navigation by sliding it down
                      }
                    },),
                  ),
                  const GiftPage(),
                  Container(),
                  const ChallengePage(),
                  const RankingPage(),
                ],
              ),
            ),
            AnimatedSwitcher(
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              duration: const Duration(milliseconds: 200),
              child: !_isExplorePage? Align(
                key: const ValueKey<int>(1),
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Navigation(
                  onChanged: (page) async {
                    if(page!=2){
                      try {
                        await FirebaseAuth.instance.currentUser!.reload();
                      } catch (e) {
                        print("THD ERROR $e");
                        setState(() {
                          context.read<AuthBloc>().add(SignOut());
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            "/auth/sign_up",
                                (route) => false,
                          );
                        });
                      }
                    }

                    setState(() {
                      context.read<user_bloc.UserBloc>().add(user_bloc.Init());
                      if (page == 1) context.read<offer_bloc.OfferBloc>().add(offer_bloc.Init());
                      if (page == 1) context.read<project_bloc.ProjectBloc>().add(project_bloc.Init());
                      if (page == 3) context.read<challenge_bloc.ChallengeBloc>().add(challenge_bloc.Init());
                      if (page == 4) context.read<ranking_bloc.RankingBloc>().add(ranking_bloc.Init());
                      if (page == 2){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ValidationLoading()));
                        });
                      }else{
                        controller.jumpToPage(page);
                      }
                      SystemChrome.setSystemUIOverlayStyle(page == 2 ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
                    });
                  },
                ),
              ),
            ):Container(),)
          ],
        ),
      ),
    );
  }
}
