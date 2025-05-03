import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/first_launch/first_launch_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/widget/page_indicator.dart';
import 'package:lottie/lottie.dart';

/// To keep the text aligned, we didnt used spacer but sizedbox with poourcentage.
/// The half of the screen is for the animations.
/// Animations are also each resized with differents values (due to the client).
/// Same for the text.
class ExplanationPage extends StatefulWidget {
  bool goHome = false;
  ExplanationPage({super.key,this.goHome = false});

  @override
  State<ExplanationPage> createState() => _ExplanationPageState();
}

class _ExplanationPageState extends State<ExplanationPage> {
  PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: BlocConsumer<FirstLaunchBloc, FirstLaunchState>(
        listener: (context, state) {
          if (state is FirstLaunchSet) {
            if(widget.goHome){
              Navigator.pushReplacementNamed(context, "/home");
            }else{
              Navigator.of(context).pushNamedAndRemoveUntil('/auth/sign_up', (Route<dynamic> route) => false);
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(kPadding20),
                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.15),
                              SizedBox(
                                height: constraints.maxHeight * 0.50,
                                child: Image.asset(
                                    "assets/images/explorez.png"),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                "Explorez !",
                                style: kBoldARPDisplay25.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: kPadding5),
                              FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Text(
                                  "Sélectionnez la ville et l’heure pour découvrir les sites touristiques pendant les heures creuses.",
                                  style: kRegularNunito19.copyWith(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Spacer(),
                            ],
                          );
                        }),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(kPadding20),
                          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                            return Column(
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.15),
                                SizedBox(
                                  height: constraints.maxHeight * 0.50,
                                  child: Image.asset(
                                      "assets/images/Consultez.png"),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  "Consultez !",
                                  style: kBoldARPDisplay25.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: kPadding5),
                                FractionallySizedBox(
                                  widthFactor: 0.9,
                                  child: Text(
                                    "Utilisez notre carte interactive pour voir l’affluence en temps réel et visiter sereinement.",
                                    style: kRegularNunito19.copyWith(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            );
                          })),
                      Container(
                        padding: const EdgeInsets.all(kPadding20),
                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.15),
                              SizedBox(
                                height: constraints.maxHeight * 0.50,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: FractionallySizedBox(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0), // Set border radius here
                                      child: Lottie.asset(
                                        "assets/animations/map.json",
                                        fit: BoxFit.cover, // To ensure the animation fits within the bounds
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                "Validez !",
                                style: kBoldARPDisplay25.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: kPadding5),
                              FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Text(
                                  "Sur place, validez votre visite pour gagner des Diamz et aidez les autres en partageant votre\nressenti d’affluence !",
                                  style: kRegularNunito19.copyWith(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Spacer(),
                            ],
                          );
                        }),
                      ),
                      Stack(
                        children: [
                          Center(
                            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                              return Container(child: Lottie.asset("assets/animations/confetis.json",width: constraints.maxWidth,height: constraints.maxHeight,fit: BoxFit.fill));
                            }),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(kPadding20),
                              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                                return Column(
                                  children: [
                                    SizedBox(height: constraints.maxHeight * 0.15),
                                    SizedBox(
                                      height: constraints.maxHeight * 0.50,
                                      child: Image.asset(
                                        fit: BoxFit.fill,
                                        "assets/images/Gagnez.png",
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      "Gagnez !",
                                      style: kBoldARPDisplay25.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: kPadding5),
                                    FractionallySizedBox(
                                      widthFactor: 0.9,
                                      child: Text(
                                        "Échangez vos Diamz contre des cadeaux exclusifs. Vos visites responsables sont ainsi récompensées !",
                                        style: kRegularNunito19.copyWith(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    PageIndicator(
                      length: 4,
                      currentIndex: currentIndex,
                      selectedColor: Colors.white,
                      unselectedColor: Colors.white.withOpacity(0.30),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kPadding20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          disabledColor: Colors.transparent,
                          onPressed: currentIndex == 3
                              ? () {
                            context.read<FirstLaunchBloc>().add(SetFirstLaunch());
                          }
                              : null,
                          icon: RotatedBox(quarterTurns:2,child: SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: currentIndex == 3
                              ? Colors.white
                              : Colors.transparent,height: 22,width: 22,)),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
