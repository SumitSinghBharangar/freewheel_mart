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

    // Safety check: Block processing if user is not logged in or uid is empty
    if (user == null || user.uid.isEmpty || amount <= 0) return false;

    _isProcessing = true;
    notifyListeners();

    try {
      final double currentBalance = double.tryParse(user.balance) ?? 0.0;
      final double newBalance = currentBalance + amount;
      final String formattedBalance = newBalance.toStringAsFixed(2);

      // 1. Update total directly inside the main user document snapshot reference
      await _firestore.collection('users').doc(user.uid).update({
        'balance': formattedBalance,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. Log an entry inside the flat ROOT 'transactions' collection instead of nested path
      final CollectionReference transactionsRoot = _firestore.collection(
        'transactions',
      );
      final String customTxId = transactionsRoot.doc().id;

      final logEntry = {
        'id': customTxId,
        'userId': user.uid, // Explicit link query key back to user
        'amount': amount,
        'type': TransactionType.deposit.name,
        'description': "Funds added via digital wallet profile Top-Up",
        'timestamp':
            FieldValue.serverTimestamp(), // Firestore server-side time anchor
      };

      await transactionsRoot.doc(customTxId).set(logEntry);

      // 3. Force-sync local data state properties instantly
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

  /// Real-time stream for user financial history logs from root collection
  Stream<List<TransactionModel>> streamTransactions(String uid) {
    // FIX: Fail-safe check. If the incoming string path is empty, return an empty stream list instantly
    if (uid.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('transactions')
        .where(
          'userId',
          isEqualTo: uid,
        ) // Filter root records targeting this user specifically
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            final data = doc.data();

            // Handle conversion if timestamp arrives from Firestore as placeholder server token
            DateTime parseTime = DateTime.now();
            if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
              parseTime = (data['timestamp'] as Timestamp).toDate();
            }

            return TransactionModel(
              id: doc.id,
              amount: (data['amount'] as num? ?? 0.0).toDouble(),
              type: TransactionType.values.byName(
                data['type'] as String? ?? 'deposit',
              ),
              description: data['description'] as String? ?? '',
              timestamp: parseTime,
            );
          }).toList(),
        );
  }
}
