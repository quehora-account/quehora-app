// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hoora/bloc/auth/auth_bloc.dart';
// import 'package:hoora/common/alert.dart';
// import 'package:hoora/common/decoration.dart';
// import 'package:hoora/widget/button.dart';
// import 'package:lottie/lottie.dart';

// class VerifyEmailPage extends StatefulWidget {
//   const VerifyEmailPage({super.key});

//   @override
//   State<VerifyEmailPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<VerifyEmailPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kSecondary,
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is VerifyEmailSuccess) {
//             Navigator.pushReplacementNamed(context, "/auth/sign_up_gift_gems");
//           }

//           if (state is VerifyEmailFailed) {
//             Alert.showError(context, "Vérifiez votre email avant de continuer !");
//           }
//         },
//         builder: (context, state) {
//           return SafeArea(
//               child: Padding(
//             padding: const EdgeInsets.all(kPadding20),
//             child: Center(
//               child: LayoutBuilder(builder: (context, constraints) {
//                 return Form(
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Confirmez votre email",
//                         style: kBoldARPDisplay25,
//                         textAlign: TextAlign.center,
//                       ),
//                       const Spacer(),
//                       const Text(
//                         "Vous avez reçu un lien de confirmation sur votre email. Une fois confirmée, vous pouvez continuer !",
//                         style: kBoldARPDisplay14,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: kPadding20),
//                       Container(
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           color: kPrimary,
//                           borderRadius: BorderRadius.circular(
//                             kRadius100,
//                           ),
//                         ),

//                         /// Remove stack when lottie animation sized changed.
//                         child: Align(
//                           alignment: Alignment.topCenter,
//                           child: Lottie.asset(
//                             "assets/animations/gem.json",
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       const SizedBox(height: kPadding20),
//                       Button(
//                           text: "Continuer",
//                           isLoading: state is VerifyEmailLoading,
//                           onPressed: () {
//                             context.read<AuthBloc>().add(VerifyEmail());
//                           }),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ));
//         },
//       ),
//     );
//   }
// }
