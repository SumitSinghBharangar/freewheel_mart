import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String mail;
  final String userAddress;
  final String imageUrl;
  final String primaryAddress;
  final String balance;
  final String role; 
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.uid = "",
    this.name = "",
    this.phone = "",
    this.mail = "",
    this.userAddress = "",
    this.imageUrl = "",
    this.primaryAddress = "",
    this.balance = "0.0",
    this.role = "user",
    this.createdAt,
    this.updatedAt,
  });

  // Convert the Model properties into a Map for Firestore writes
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'phone': phone,
      'mail': mail,
      'userAddress': userAddress,
      'imageUrl': imageUrl,
      'balance': balance,
      'primaryAddress': primaryAddress,
      'role': role,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }

  // Factory Constructor to securely parse incoming Firestore document data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? "",
      name: map['name'] as String? ?? "",
      phone: map['phone'] as String? ?? "",
      mail: map['mail'] as String? ?? "",
      balance: map['balance'] as String? ?? "0.0",
      userAddress: map['userAddress'] as String? ?? "",
      imageUrl: map['imageUrl'] as String? ?? "",
      primaryAddress: map['primaryAddress'] as String? ?? "",
      role: map['role'] as String? ?? "user",
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}