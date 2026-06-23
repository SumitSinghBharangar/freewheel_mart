import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freewheel_mart/features/auth/provider/auth_provider.dart';
import 'package:freewheel_mart/features/cart/data/cart_item_model.dart';
import 'package:freewheel_mart/features/shop/data/product_model.dart';
import 'package:freewheel_mart/features/wallet/data/transection_model.dart';
import 'package:freewheel_mart/features/wallet/provider/wallet_provider.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => {..._items};

  int get totalItemCount {
    int total = 0;
    _items.forEach((key, cartItem) => total += cartItem.quantity);
    return total;
  }

  double get totalCartAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) => total += cartItem.totalLinePrice);
    return total;
  }

  void addToCart(ProductModel product) {
    if (product.id == null) return;

    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id!] = CartItemModel(product: product);
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Deducts balance from wallet, clears cart, and records a 'purchase' log in the flat transaction collection
  Future<String?> processCheckout({
    required AuthProvider auth,
    required WalletProvider wallet,
  }) async {
    final user = auth.currentUserModel;
    if (user == null || user.uid.isEmpty)
      return "Authentication error. Please re-login.";
    if (_items.isEmpty) return "Your shopping cart is completely empty.";

    final double totalCost = totalCartAmount;
    final double userBalance = double.tryParse(user.balance) ?? 0.0;

    if (userBalance < totalCost) {
      return "Insufficient wallet balance. Please add funds to your card.";
    }

    try {
      final double updatedBalance = userBalance - totalCost;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // 1. Atomically update the user's primary wallet balance in Firestore
      await firestore.collection('users').doc(user.uid).update({
        'balance': updatedBalance.toStringAsFixed(2),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. Generate a standalone checkout log inside the standalone 'transactions' collection
      final CollectionReference txRoot = firestore.collection('transactions');
      final String customTxId = txRoot.doc().id;

      final checkoutLog = {
        'id': customTxId,
        'userId': user.uid,
        'amount': totalCost,
        'type': TransactionType.purchase.name,
        'description':
            "Purchased $totalItemCount premium gear item(s) via checkout processing",
        'timestamp': FieldValue.serverTimestamp(),
      };

      await txRoot.doc(customTxId).set(checkoutLog);

      // 3. Resync local user auth state values instantly
      await auth.fetchAndSyncUserDetails(user.uid);

      // 4. Wipe cart clean on success
      clearCart();
      return null;
    } catch (e) {
      return "Transaction failed during communication: ${e.toString()}";
    }
  }
}
