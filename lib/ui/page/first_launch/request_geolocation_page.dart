import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/first_launch/first_launch_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/alert.dart';
import 'package:lottie/lottie.dart';

class RequestGeolocationPage extends StatelessWidget {
  const RequestGeolocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: BlocConsumer<FirstLaunchBloc, FirstLaunchState>(
        listener: (context, state) {
          if (state is GeolocationDenied) {
            Alert.showError(context, "Veuillez autoriser la géolocalisation dans vos paramètres.");
          }
          if (state is GeolocationAccepted) {
            Navigator.pushNamed(context, "/first_launch/explanation");
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(kPadding20),
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.25),
                      SizedBox(
                        height: constraints.maxHeight * 0.25,
                        child: Align(
                          child: Lottie.asset(
                            "assets/animations/gps.json",
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      const Text(
                        "Votre position",
                        style: kBoldARPDisplay25,
                      ),
                      const SizedBox(height: kPadding5),
                      const FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Text(
                          "Pour vous proposer les meilleurs sites autours de vous, Quehora a besoin d'accèder à votre position géographique.",
                          style: kRegularNunito20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            context.read<FirstLaunchBloc>().add(RequestGeolocation());
                          },
                          icon: const Icon(
                            CupertinoIcons.arrow_right,
                            size: 32,
                            color: kPrimary,
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
