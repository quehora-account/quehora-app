class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }

    bool hasMatch = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(value);

    if (!hasMatch) {
      return "Votre email n'est pas valide.";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }
    if (value.length < 8) {
      return "Votre mot de passe doit contenir minimum 8 charactères.";
    }

    if (value.length > 64) {
      return "Votre mot de passe doit contenir maximum 64 charactères.";
    }
    return null;
  }

  static String? confirmPassword(String password, String passwordToConfirm) {
    if (passwordToConfirm.isEmpty) {
      return 'Ce champ est vide.';
    }

    if (password.compareTo(passwordToConfirm) != 0) {
      return 'Le mot de passe ne correspond pas.';
    }

    return null;
  }

  static String? isNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est vide.';
    }
    return null;
  }

  static String? nicknameHasGoodFormat(String? value) {
    if (value == null || value.length < 3 || value.length > 10) {
      return 'Le pseudo doit comporter entre 3 et 10 caractères.';
    }
    return null;
  }

}
