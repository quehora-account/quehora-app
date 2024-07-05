import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  final FirebaseAuth _instance = FirebaseAuth.instance;

  Future<bool> signInWithApple() async {
    AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    OAuthProvider oAuthProvider = OAuthProvider("apple.com");
    OAuthCredential oAuthCredential = oAuthProvider.credential(
      idToken: appleCredential.identityToken!,
      accessToken: appleCredential.authorizationCode,
    );

    UserCredential user = await _instance.signInWithCredential(oAuthCredential);
    return user.additionalUserInfo!.isNewUser;
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleCredential = await account!.authentication;

    final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleCredential.accessToken!,
      idToken: googleCredential.idToken,
    );

    UserCredential user = await _instance.signInWithCredential(oAuthCredential);
    return user.additionalUserInfo!.isNewUser;
  }

  Future<bool> signIn(String email, String password) async {
    UserCredential user = await _instance.signInWithEmailAndPassword(email: email, password: password);
    return user.additionalUserInfo!.isNewUser;
  }

  Future<void> signUp(String email, String password) async {
    await _instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _instance.signOut();
  }

  Future<void> delete() async {
    await _instance.currentUser!.delete();
  }

  Future<void> forgotPassword(String email) async {
    await _instance.sendPasswordResetEmail(email: email);
  }
}
