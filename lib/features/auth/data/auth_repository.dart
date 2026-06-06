import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream to listen to real-time authentication state changes.
  /// Emits a Firebase [User] object when login status updates.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Retrieve the currently authenticated Firebase user instance.
  User? get currentUser => _auth.currentUser;

  /// Creates a user account in Firebase Auth and builds an explicit matching
  /// database profile inside the Cloud Firestore 'users' collection.
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // 1. Create native auth record
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        // 2. Initialize the structured UserModel payload with defaults
        UserModel newUser = UserModel(
          uid: user.uid,
          name: fullName,
          mail: email,
          role: 'user',
          balance: '0.0',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // 3. Commit map payload serialization straight into Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during registration.';
    }
  }

  /// Authenticates an existing user record via Email and Password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during sign-in.';
    }
  }

  /// Fetches a user's database record completely compiled into a UserModel instance.
  /// Returns null if the underlying Firestore document does not exist.
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch user profile details from database.';
    }
  }

  /// Updates profile metadata fields (like physical addresses or phone numbers)
  /// within a specific user document using your model's schema.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.uid)
          .update(updatedUser.toMap());
    } catch (e) {
      throw 'Failed to sync updated profile configurations.';
    }
  }

  /// Terminates the current device session.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Explicit translation handler for Firebase native exceptions into clean user warnings.
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak. Try adding symbols or numbers.';
      case 'email-already-in-use':
        return 'An account already exists under this email address.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password credentials. Please verify and try again.';
      case 'invalid-email':
        return 'The email address configuration format is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled by administration.';
      case 'too-many-requests':
        return 'Too many requests. System access blocked temporarily to protect security.';
      default:
        return e.message ?? 'An unknown authorization obstacle occurred.';
    }
  }
}
