import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/first_launch/first_launch_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/widget/page_indicator.dart';
import 'package:lottie/lottie.dart';

/// To keep the text aligned, we didnt used spacer but sizedbox with poourcentage.
/// The half of the screen is for the animations.
/// Animations are also each resized with differents values (due to the client).
/// Same for the text.
class ExplanationPage extends StatefulWidget {
  const ExplanationPage({super.key});

  @override
  State<ExplanationPage> createState() => _ExplanationPageState();
}

class _ExplanationPageState extends State<ExplanationPage> {
  PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      body: BlocConsumer<FirstLaunchBloc, FirstLaunchState>(
        listener: (context, state) {
          if (state is FirstLaunchSet) {
            Navigator.of(context).pushNamedAndRemoveUntil('/auth/sign_up', (Route<dynamic> route) => false);
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
                                child: Lottie.asset(
                                    "assets/animations/people.json"),
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
                                  child: Lottie.asset(
                                      "assets/animations/time.json"),
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
                      Padding(
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
                                    child: Lottie.asset(
                                      "assets/animations/validation.json",
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
                      Padding(
                        padding: const EdgeInsets.all(kPadding20),
                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.15),
                              SizedBox(
                                height: constraints.maxHeight * 0.50,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 40),
                                  child: FractionallySizedBox(
                                    child: Lottie.asset(
                                      "assets/animations/treasure.json",
                                    ),
                                  ),
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
                          icon: Icon(
                            CupertinoIcons.arrow_right,
                            size: 32,
                            color: currentIndex == 3
                                ? Colors.white
                                : Colors.transparent,
                          ),
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
