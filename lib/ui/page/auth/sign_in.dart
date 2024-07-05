import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/validator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignInFailed) {
            Alert.showError(context, state.exception.message);
          }

          if (state is SignInSuccess) {
            if (state.isNewUser) {
              Navigator.pushNamed(context, "/auth/sign_up_gift_gems");
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/home",
                (route) => false,
              );
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(kPadding20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).padding.top),
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
                          const Text(
                            "Se connecter",
                            style: kBoldARPDisplay25,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Email",
                              style: kRegularNunito14,
                            ),
                          ),
                          const SizedBox(height: kPadding5),
                          TextFormField(
                            style: kRegularNunito18,
                            decoration: kTextFieldStyle.copyWith(prefixIcon: const Icon(CupertinoIcons.mail)),
                            controller: emailController,
                            validator: Validator.email,
                          ),
                          const SizedBox(height: kPadding10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Mot de passe",
                              style: kRegularNunito14,
                            ),
                          ),
                          const SizedBox(height: kPadding5),
                          TextFormField(
                            obscureText: true,
                            style: kRegularNunito18,
                            decoration: kTextFieldStyle.copyWith(
                                prefixIcon: const Icon(CupertinoIcons.lock), hintText: "Mot de passe"),
                            controller: passwordController,
                            validator: Validator.password,
                          ),
                          const SizedBox(height: kPadding20),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: kButtonStyle,
                              onPressed: state is SignInLoading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                            SignIn(email: emailController.text, password: passwordController.text));
                                      }
                                    },
                              child: state is SignInLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white),
                                    )
                                  : Text(
                                      "Se connecter",
                                      style: kBoldNunito16.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            // child: ElevatedButton(
                            //   style: kButtonStyle,
                            //   onPressed: state is ForgotPasswordLoading
                            //       ? null
                            //       : () {
                            //           if (formKey.currentState!.validate()) {
                            //             context.read<AuthBloc>().add(ForgotPassword(email: emailController.text));
                            //           }
                            //         },
                            //   child: state is ForgotPasswordLoading
                            //       ? const SizedBox(
                            //           height: 20,
                            //           width: 20,
                            //           child: CircularProgressIndicator(color: Colors.white),
                            //         )
                            //       : Text(
                            //           "Réinitialiser",
                            //           style: kBoldNunito16.copyWith(
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            // ),
                          ),
                          const SizedBox(height: kPadding20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: kPadding20),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: kPrimary,
                                ),
                              ),
                              SizedBox(width: kPadding10),
                              Text("Ou", style: kRegularNunito14),
                              SizedBox(width: kPadding10),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: kPrimary,
                                ),
                              ),
                              SizedBox(width: kPadding20),
                            ],
                          ),
                          const SizedBox(height: kPadding20),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: kButtonStyle,
                              onPressed: state is SignUpWithGoogleLoading
                                  ? null
                                  : () {
                                      context.read<AuthBloc>().add(SignInWithGoogle());
                                    },
                              child: state is SignUpWithGoogleLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white),
                                    )
                                  : Text(
                                      "Continuer avec Google",
                                      style: kBoldNunito16.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          if (Platform.isIOS)
                            Column(
                              children: [
                                const SizedBox(height: kPadding10),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: kButtonStyle,
                                    onPressed: state is SignUpWithAppleLoading
                                        ? null
                                        : () {
                                            context.read<AuthBloc>().add(SignInWithApple());
                                          },
                                    child: state is SignUpWithAppleLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(color: Colors.white),
                                          )
                                        : Text(
                                            "Continuer avec Apple",
                                            style: kBoldNunito16.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: kPadding10),
                          SizedBox(
                            height: 20,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "/auth/forgot_password");
                              },
                              child: const Text(
                                "Mot de passe oublié ?",
                                style: kRegularNunito14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
