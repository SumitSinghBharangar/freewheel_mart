import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String? name;
  String? description;
  double? price;
  String? category;
  String? subCategory;
  List<String>? images; // Array of Cloudinary asset strings
  int? stockQuantity;
  Map<String, dynamic>? specifications;
  double? rating;

  DateTime? createdAt;
  DateTime? updatedAt;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    this.subCategory,
    this.images,
    this.stockQuantity,
    this.specifications,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  // Convert the Product Model properties into a Map for Firestore writes
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'subCategory': subCategory,
      'images': images,
      'stockQuantity': stockQuantity,
      'specifications': specifications,
      'rating': rating,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  // Factory Constructor to securely parse incoming Firestore document data
  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      name: map['name'] as String? ?? "",
      description: map['description'] as String? ?? "",
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] as String? ?? "",
      subCategory: map['subCategory'] as String? ?? "",
      images: map['images'] != null
          ? List<String>.from(map['images'] as List)
          : [],
      stockQuantity: map['stockQuantity'] as int? ?? 0,
      specifications: map['specifications'] != null
          ? map['specifications'] as Map<String, dynamic>
          : {},
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source, String documentId) =>
      ProductModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
        documentId,
      );
}
