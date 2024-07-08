import 'package:flutter/material.dart';

final ThemeData kTheme = ThemeData(inputDecorationTheme: const InputDecorationTheme(errorMaxLines: 10));

const Color kPrimary = Color.fromRGBO(14, 22, 38, 1);
const Color kPrimary3 = Color.fromRGBO(206, 202, 255, 1);
const Color kSecondary = Color.fromRGBO(197, 248, 220, 1);
// const Color kBackground = Color.fromRGBO(249, 250, 251, 1);
const Color kBackground = Colors.white;
const Color kDarkBackground = Color(0xFF0E1626);
const Color kNavigationIconSelected = Color.fromRGBO(161, 154, 255, 1);
const Color kUnselected = Color.fromRGBO(241, 240, 255, 1);
const Color kGemsIndicator = Color.fromRGBO(241, 240, 255, 1);

const double kPadding40 = 40;
const double kPadding20 = 20;
const double kPadding10 = 10;
const double kPadding5 = 5;

const double kRadius10 = 10;
const double kRadius20 = 20;
const double kRadius100 = 100;

const TextStyle kBoldARPDisplay32 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 32,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay25 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 25,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay20 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 20,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay14 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 14,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay18 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 18,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay16 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 16,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay13 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 13,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay11 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 11,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldARPDisplay12 = TextStyle(
  fontFamily: "ARPDisplay",
  fontSize: 12,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularNunito20 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldNunitoTest = TextStyle(
  fontFamily: "NunitoBlack",
  fontSize: 30,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldNunito16 = TextStyle(
  fontFamily: "NunitoBlack",
  fontSize: 16,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);
const TextStyle kBoldNunito20 = TextStyle(
  fontFamily: "NunitoBlack",
  fontSize: 20,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularNunito10 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 10,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularNunito11 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 11,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularNunito12 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularNunito14 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularNunito16 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldNunito10 = TextStyle(
  fontFamily: "NunitoBlack",
  fontSize: 10,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldNunito14 = TextStyle(
  fontFamily: "NunitoBlack",
  fontSize: 14,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kBoldNunito12 = TextStyle(
  fontFamily: "NunitoBlack",
  fontSize: 12,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kRBoldNunito18 = TextStyle(
  fontFamily: "NunitoBlack",
  fontSize: 18,
  fontWeight: FontWeight.w900,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularNunito18 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 18,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

const TextStyle kRegularNunito19 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 19,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);


const TextStyle kRegularNunito32 = TextStyle(
  fontFamily: "Nunito",
  fontSize: 32,
  fontWeight: FontWeight.w400,
  color: kPrimary,
  height: 1,
);

InputDecoration kTextFieldStyle = InputDecoration(
  hintText: "Email",
  hintStyle: kRegularNunito18.copyWith(
    color: Colors.black.withOpacity(0.5),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(kRadius10),
    borderSide: const BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
  fillColor: Colors.white,
  filled: true,
);

ButtonStyle kButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimary,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(kRadius10),
  ),
  disabledBackgroundColor: kPrimary,
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
);

ButtonStyle kButtonRoundedStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimary,
  shape: const StadiumBorder(),
  disabledBackgroundColor: kPrimary,
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
);

ButtonStyle kButtonRoundedPrimary3Style = ElevatedButton.styleFrom(
  backgroundColor: kPrimary3,
  shape: const StadiumBorder(),
  disabledBackgroundColor: kPrimary3,
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
);

ButtonStyle kButtonRoundedLightStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  shape: const StadiumBorder(),
  disabledBackgroundColor: kPrimary,
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
);
