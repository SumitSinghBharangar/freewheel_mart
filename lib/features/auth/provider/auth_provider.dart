import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freewheel_mart/features/auth/data/auth_repository.dart';
import 'package:freewheel_mart/features/auth/data/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUserModel;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUserModel => _currentUserModel;

  Stream<User?> get authStateStream => _authRepository.authStateChanges;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      UserCredential credentials = await _authRepository
          .signInWithEmailAndPassword(email: email, password: password);

      if (credentials.user != null) {
        // Fetch complete explicit data model profiles from Firestore
        await fetchAndSyncUserDetails(credentials.user!.uid);
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordReset({required String email}) async {
    _setLoading(true);
    _clearError();
    try {
      await _authRepository.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> fetchAndSyncUserDetails(String uid) async {
    try {
      _currentUserModel = await _authRepository.getUserDetails(uid);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
    _currentUserModel = null;
    notifyListeners();
  }
}
