import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;
  bool _isLoading = false;
  String? _errorMessage;

  AppAuthProvider(this._firebaseService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => FirebaseAuth.instance.currentUser;

  Stream<User?> get authStateChanges => _firebaseService.authStateChanges;

  Future<void> login(String email, String password) async {
    _errorMessage = null;
    _setLoading(true);
    try {
      await _firebaseService.login(email, password);
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error: ${e.code}");
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = "No user found with this email. Please sign up.";
          break;
        case 'wrong-password':
          _errorMessage = "Incorrect password. Please try again.";
          break;
        case 'invalid-email':
          _errorMessage = "The email address is not valid.";
          break;
        case 'user-disabled':
          _errorMessage = "This user account has been disabled.";
          break;
        case 'invalid-credential':
          _errorMessage = "Invalid login details. Please check your email and password.";
          break;
        default:
          _errorMessage = e.message ?? "An unexpected error occurred.";
      }
    } catch (e) {
      _errorMessage = "Network error. Please check your connection.";
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password) async {
    _errorMessage = null;
    _setLoading(true);
    try {
      await _firebaseService.signUp(email, password);
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error: ${e.code}");
      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage = "This email is already registered. Please login.";
          break;
        case 'weak-password':
          _errorMessage = "Password is too weak. Please use at least 6 characters.";
          break;
        default:
          _errorMessage = e.message ?? "An error occurred during signup.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _firebaseService.logout();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
