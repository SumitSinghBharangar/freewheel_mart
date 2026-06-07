import 'package:flutter/material.dart';
import 'package:freewheel_mart/features/shop/data/product_model.dart';
import 'package:freewheel_mart/features/shop/data/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  /// Dynamic Category state switcher
  void setCategory(String categoryName) {
    _selectedCategory = categoryName;
    notifyListeners();
  }

  /// Dynamically fetch product stream based on category choice
  Stream<List<ProductModel>> get productsStream {
    if (_selectedCategory == 'All') {
      return _productRepository.streamAllProducts();
    } else {
      return _productRepository.streamProductsByCategory(_selectedCategory);
    }
  }
}
