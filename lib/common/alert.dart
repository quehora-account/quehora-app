import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class Alert {
  static showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0E1626),
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: kRegularNunito20.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  static showSuccess(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kPrimary,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: kRegularNunito20.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  static showSuccessWidget(BuildContext context, Widget child) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kPrimary,
        content: child,
      ),
    );
  }
}

class AlertException {
  final String message;

  AlertException({required this.message});

  factory AlertException.fromException(Object exception) {
    String message = "Oups... Une erreur est survenue.";

    print(exception);

    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case "email-already-exists":
          message = "L'email fourni est déjà utilisée par un autre utilisateur.";
          break;
        case "email-already-in-use":
          message = "L'email fourni est déjà utilisée par un autre utilisateur.";
          break;
        case "invalid-email":
          message = "L'email fourni ne peut pas être utilisé.";
          break;
        case "invalid-password":
          message = "Mot de passe trop court.";
          break;
        case "invalid-credential":
          message = "Mot de passe ou email incorrect.";
          break;
        case "user-not-found":
          message = "L'email fourni est introuvable.";
          break;
        case "too-many-requests":
          message = "Veuillez réessayer plus tard.";
          break;
        case "requires-recent-login":
          message = "Veuillez vous reconnecter pour effectuer cette action.";
          break;
      }
    }

    return AlertException(message: message);
  }
}
