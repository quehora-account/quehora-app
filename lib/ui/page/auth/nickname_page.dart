import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/validator.dart';
import 'package:lottie/lottie.dart';

class NicknamePage extends StatefulWidget {
  const NicknamePage({super.key});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final TextEditingController nicknameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is SetNicknameFailed) {
          Alert.showError(context, state.exception.message);
        }

        if (state is NicknameNotAvailable) {
          Alert.showSuccess(context, "\"${state.nickname}\" est déjà utilisé par un autre utilisateur.");
        }

        if (state is SetNicknameSuccess) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kSecondary,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(kPadding20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      const SizedBox(height: kPadding40),
                      const FractionallySizedBox(
                        child: Text(
                          "Comment on\nvous appelle ?",
                          textAlign: TextAlign.center,
                          style: kBoldARPDisplay25,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 155,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: LottieBuilder.asset(
                                "assets/animations/gem.json",
                                height: 110,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 125,
                                width: 125,
                                child: SvgPicture.asset("assets/svg/ranking_gem.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: kPadding20),
                      const Text(
                        "Choisissez le nom avec\nlequel  vous apparaîtrez\ndans notre classement.",
                        style: kBoldARPDisplay14,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pseudo",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        maxLength: 10,
                        style: kRegularNunito18,
                        decoration: kTextFieldStyle.copyWith(hintText: ""),
                        controller: nicknameController,
                        validator: Validator.nicknameHasGoodFormat,
                      ),
                      const SizedBox(height: kPadding20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: kButtonStyle,
                          onPressed: state is SetNicknameLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<UserBloc>().add(
                                          SetNickname(
                                            nickname: nicknameController.text,
                                          ),
                                        );
                                  }
                                },
                          child: state is SetNicknameLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : Text(
                                  "C'est partiiiii !",
                                  style: kBoldNunito16.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
