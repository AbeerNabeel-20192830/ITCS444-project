import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin_emails.dart';

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

      await _checkAdminRole();
      notifyListeners();
    } catch (e) {
      throw Exception(e);
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

      await _checkAdminRole();
      notifyListeners();
    } catch (e) {
      throw Exception(e);
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
      throw Exception(e);
    }
  }

  // Check if user is admin
  Future<void> _checkAdminRole() async {
    if (_user != null) {
      if (adminEmails.contains(_user!.email)) {
        _isAdmin = true;
      }
    } else {
      _isAdmin = false;
    }
    notifyListeners();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _user != null;
  }
}
