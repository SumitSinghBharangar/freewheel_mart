import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { deposit, purchase, refund }

class TransactionModel {
  final String id;
  final double amount;
  final TransactionType type;
  final String description;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type.name,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return TransactionModel(
      id: documentId,
      amount: (map['amount'] as num).toDouble(),
      type: TransactionType.values.byName(map['type'] as String),
      description: map['description'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
