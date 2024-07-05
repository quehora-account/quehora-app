import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordFailed) {
            Alert.showError(context, state.exception.message);
          }

          if (state is ForgotPasswordSuccess) {
            Alert.showSuccess(context, "Un email de réinitialisation a été envoyé.");
            Navigator.pop(context);
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
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
                          ),
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
                          // Asked by the client.
                          const FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Text(
                              "Réinitialiser le mot de passe ?",
                              textAlign: TextAlign.center,
                              style: kBoldARPDisplay25,
                            ),
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
                          const SizedBox(height: kPadding20),

                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: kButtonStyle,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(ForgotPassword(email: emailController.text));
                                }
                              },
                              child: state is ForgotPasswordLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white),
                                    )
                                  : Text(
                                      "Réinitialiser",
                                      style: kBoldNunito16.copyWith(
                                        color: Colors.white,
                                      ),
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
