import 'package:clothify_app/controllers/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String> createAccountWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await DbService().saveUserData(name: name, email: email);
      return "Account created successfully";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

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

  Future<String> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "Logout successful";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Password reset email sent";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
