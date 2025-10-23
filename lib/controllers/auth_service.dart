import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // create new account using email password method
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Account created successfully";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // login with email password method
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Login successful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // logout method
  Future<String> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "Logout successful";
    } catch (e) {
      return e.toString();
    }
  }

  //reset password method
  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Password reset email sent";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // check if user is logged in
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
