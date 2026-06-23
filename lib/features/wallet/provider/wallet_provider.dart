import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freewheel_mart/features/auth/data/user_model.dart';
import 'package:freewheel_mart/features/auth/provider/auth_provider.dart';
import 'package:freewheel_mart/features/wallet/data/transection_model.dart';

class WalletProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  /// Simulates depositing funds into the user's wallet
  Future<bool> depositFunds({
    required AuthProvider authProvider,
    required double amount,
  }) async {
    final UserModel? user = authProvider.currentUserModel;
    if (user == null || amount <= 0) return false;

    _isProcessing = true;
    notifyListeners();

    try {
      final double currentBalance = double.tryParse(user.balance) ?? 0.0;
      final double newBalance = currentBalance + amount;

      // 1. Update total inside Firestore user document snapshot
      await _firestore.collection('users').doc(user.uid).update({
        'balance': newBalance.toStringAsFixed(2),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. Log an entry inside the transaction nested collection tracking store
      final transactionRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc();

      final logEntry = TransactionModel(
        id: transactionRef.id,
        amount: amount,
        type: TransactionType.deposit,
        description: "Funds added via digital wallet profile Top-Up",
        timestamp: DateTime.now(),
      );

      await transactionRef.set(logEntry.toMap());

      // 3. Refresh user data state profiles
      await authProvider.fetchAndSyncUserDetails(user.uid);

      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Real-time listener stream for user financial history logs
  Stream<List<TransactionModel>> streamTransactions(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
