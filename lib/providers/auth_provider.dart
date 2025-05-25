import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  User? _user;
  bool _isLoading = false;
  bool _biometricEnabled = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get biometricEnabled => _biometricEnabled;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
    _loadBiometricSetting();
  }

  Future<void> _loadBiometricSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Google Sign In Error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Email Sign In Error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Email Sign Up Error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) return false;

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access FinGenius',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      print('Biometric Auth Error: $e');
      return false;
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', enabled);
    _biometricEnabled = enabled;
    notifyListeners();
  }
}
