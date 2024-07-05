import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart' as user_bloc;
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/auth/sign_up.dart';
import 'package:hoora/ui/page/first_launch/welcome_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
    context.read<user_bloc.UserBloc>().add(user_bloc.Init());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// back button
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
                const SizedBox(height: kPadding20),
                buildBox(),
                const SizedBox(height: kPadding10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/home/earnings/settings/traffic_point");
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Comment sont calculés mes Diamz ?",
                    style: kRegularNunito16,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/home/earnings/settings/profile");
                  },
                  child: const Text(
                    "Mes informations",
                    style: kRegularNunito16,
                  ),
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/home/earnings/settings/faq");
                  },
                  child: const Text(
                    "F.A.Q",
                    style: kRegularNunito16,
                  ),
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/home/earnings/settings/privacy");
                  },
                  child: const Text(
                    "Confidentialité",
                    style: kRegularNunito16,
                  ),
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/home/earnings/settings/feedback");
                  },
                  child: Row(
                    children: [
                      const Text(
                        "Donner un retour sur l'application",
                        style: kRegularNunito16,
                      ),
                      const SizedBox(width: kPadding10),
                      SvgPicture.asset("assets/svg/storm.svg"),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    showSignOutPopup();
                  },
                  child: const Text(
                    "Se déconnecter",
                    style: kRegularNunito16,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    showDeletePopup();
                  },
                  child: const Text(
                    "Supprimer mon compte",
                    style: kRegularNunito16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBox() {
    return Container(
      width: double.infinity,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Bravo !", style: kBoldARPDisplay25),
            const SizedBox(height: kPadding10),
            Text(
              "Grâce à vos visites hors pic, vous avez allégé la fréquentation de ${context.read<user_bloc.UserBloc>().user.amountSpotValidated} sites.",
              style: kRegularNunito14,
            ),
            const SizedBox(height: kPadding10),
            const Text(
              "Votre choix a permis :",
              style: kRegularNunito14,
            ),
            const SizedBox(height: kPadding10),
            RichText(
              text: const TextSpan(
                style: kRegularNunito14,
                children: [
                  TextSpan(
                    text: '1. ',
                    style: kBoldNunito14,
                  ),
                  TextSpan(
                    text: 'D\'améliorer l\'expérience de visite pour tous !',
                  ),
                  TextSpan(
                    text: '\n2. ',
                    style: kBoldNunito14,
                  ),
                  TextSpan(
                    text: 'De diminuer la pression sur les infrastructures touristiques.',
                  ),
                  TextSpan(
                    text: '\n3. ',
                    style: kBoldNunito14,
                  ),
                  TextSpan(
                    text: 'De réduire les coûts de maintenance et la consommation d\'énergie des lieux visités.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: kPadding10),
            const Text(
              "Merci d'opter pour un tourisme plus durable !",
              style: kBoldNunito14,
            ),
          ],
        ),
      ),
    );
  }

  void showSignOutPopup() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SignOutSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(),
                ),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(kPadding20),
              backgroundColor: kBackground,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Etes-vous vraiment sûr de vouloir vous déconnecter ? ',
                    style: kRBoldNunito18,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kPadding20),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is SignOutLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(SignOut());
                            },
                      style: kButtonRoundedStyle,
                      child: state is SignOutLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : Text(
                              "Se déconnecter",
                              style: kBoldNunito16.copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Annuler",
                        style: kRegularNunito16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showDeletePopup() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is DeleteSuccess) {
              Alert.showSuccess(context, "Votre compte a été supprimé.");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomePage(),
                ),
                (route) => false,
              );
            }

            if (state is RequiresRecentLogin) {
              /// Display error
              Alert.showSuccess(context, state.exception.message);

              /// Redirect to login page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(),
                ),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(kPadding20),
              backgroundColor: kBackground,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Voulez-vous vraiment supprimer votre compte ?',
                    style: kRBoldNunito18,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kPadding10),
                  const Text(
                    'En supprimant votre compte, vous perdrez l\'ensemble de votre progression, vos Diamz, vos avantages et tous vos achats en cours seront annulés.',
                    style: kRegularNunito12,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kPadding20),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is DeleteLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(Delete());
                            },
                      style: kButtonRoundedStyle,
                      child: state is DeleteLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : Text(
                              "Supprimer mon compte",
                              style: kBoldNunito16.copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Annuler",
                        style: kRegularNunito16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
