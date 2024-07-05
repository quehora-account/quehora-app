import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/validator.dart';
import 'package:hoora/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserBloc userBloc;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  DateTime? birthday;
  Gender gender = Gender.male;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String originalNickname;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    emailController.text = userBloc.email;
    nicknameController.text = userBloc.user.nickname;
    originalNickname = userBloc.user.nickname;
    lastnameController.text = userBloc.user.lastname;
    firstnameController.text = userBloc.user.firstname;
    cityController.text = userBloc.user.city;
    countryController.text = userBloc.user.country;
    birthday = userBloc.user.birthday;
    birthdayController.text = userBloc.user.birthday == null
        ? ""
        : "${userBloc.user.birthday!.day}/${userBloc.user.birthday!.month}/${userBloc.user.birthday!.year}";

    if (userBloc.user.gender != null) {
      gender = userBloc.user.gender!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            /// Display success message
            Alert.showSuccess(context, "Votre profil a été mis à jour !");

            /// Update original nickname
            originalNickname = nicknameController.text;
          }

          if (state is NicknameNotAvailable) {
            Alert.showError(context, "\"${state.nickname}\" est déjà utilisé par un autre utilisateur.");
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
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
                      const Center(
                          child: Text(
                        "Mes informations",
                        style: kBoldARPDisplay14,
                      )),
                      const SizedBox(height: kPadding10),
                      SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          style: kButtonRoundedPrimary3Style,
                          onPressed: state is UpdateProfileLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    userBloc.add(UpdateProfile(
                                      nickname: nicknameController.text,
                                      hasNicknameChanged: originalNickname != nicknameController.text,
                                      firstname: firstnameController.text,
                                      lastname: lastnameController.text,
                                      city: cityController.text,
                                      country: countryController.text,
                                      birthday: birthday,
                                      gender: gender,
                                    ));
                                  }
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kPadding20, vertical: kPadding10),
                            child: state is UpdateProfileLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: kPrimary,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Sauvegarder",
                                    style: kBoldNunito16,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: kPadding20),

                      /// Email
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        readOnly: true,
                        style: kRegularNunito18,
                        decoration: kTextFieldStyle,
                        controller: emailController,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Nickname
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pseudo",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularNunito18,
                        decoration: kTextFieldStyle.copyWith(hintText: ""),
                        controller: nicknameController,
                        validator: Validator.isNotEmpty,
                        maxLength: 10,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Firstname
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Prénom",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularNunito18,
                        decoration: kTextFieldStyle.copyWith(hintText: ""),
                        controller: firstnameController,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Lastname
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nom",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularNunito18,
                        decoration: kTextFieldStyle.copyWith(hintText: ""),
                        controller: lastnameController,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Birthday
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Date de naissance",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        readOnly: true,
                        style: kRegularNunito18,
                        decoration: kTextFieldStyle.copyWith(hintText: ""),
                        controller: birthdayController,
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (date != null) {
                            setState(() {
                              birthdayController.text = "${date.day}/${date.month}/${date.year}";
                              birthday = date;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: kPadding20),

                      /// Type
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Genre",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(kRadius10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                          child: DropdownButton<Gender>(
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(kRadius10),
                              style: kRegularNunito18,
                              value: gender,
                              underline: Container(),
                              items: const [
                                DropdownMenuItem(
                                    value: Gender.male,
                                    child: Text(
                                      'Homme',
                                      style: kRegularNunito18,
                                    )),
                                DropdownMenuItem(
                                    value: Gender.female,
                                    child: Text(
                                      'Femme',
                                      style: kRegularNunito18,
                                    )),
                                DropdownMenuItem(
                                    value: Gender.other,
                                    child: Text(
                                      'Autre',
                                      style: kRegularNunito18,
                                    )),
                              ],
                              onChanged: (newGender) {
                                setState(() {
                                  gender = newGender!;
                                });
                              }),
                        ),
                      ),

                      const SizedBox(height: kPadding20),

                      /// City
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ville",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularNunito18,
                        decoration: kTextFieldStyle.copyWith(hintText: ""),
                        controller: cityController,
                      ),
                      const SizedBox(height: kPadding20),

                      /// Country
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pays",
                          style: kRegularNunito14,
                        ),
                      ),
                      const SizedBox(height: kPadding5),
                      TextFormField(
                        style: kRegularNunito18,
                        decoration: kTextFieldStyle.copyWith(hintText: ""),
                        controller: countryController,
                      ),
                      const SizedBox(height: kPadding20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String genderToString(Gender gender) {
    if (gender == Gender.male) {
      return "Homme";
    } else if (gender == Gender.female) {
      return "Femme";
    }
    return "Autre";
  }
}
