import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isAdmin = false;

  Authentication() {
    _user = _auth.currentUser;
    if (_user != null) {
      _checkAdminRole();
    }
  }

  User? get user => _user;
  bool get isAdmin => _isAdmin;

  // register with email and password
  Future<void> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Send email verification
      if (_user != null && !_user!.emailVerified) {
        await _user!.sendEmailVerification();
        throw Exception(
            'A verification email has been sent to $email. Please verify your email before logging in.');
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Log in with email and password
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Check if email is verified
      if (_user != null && !_user!.emailVerified) {
        await _auth.signOut();
        throw Exception(
            'Email not verified. Please check your inbox and verify your email.');
      }

      await _checkAdminRole(); // Check if the user is an admin
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to log in: $e');
    }
  }

  // Log out
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      _isAdmin = false;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }

  // Check if user is admin
  Future<void> _checkAdminRole() async {
    if (_user != null) {
      final idTokenResult = await _user!.getIdTokenResult();
      _isAdmin = idTokenResult.claims?['admin'] ?? false;
    } else {
      _isAdmin = false;
    }
    notifyListeners();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _user != null;
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}
