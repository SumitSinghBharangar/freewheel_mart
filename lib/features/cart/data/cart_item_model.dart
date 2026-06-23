import 'package:freewheel_mart/features/shop/data/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  double get totalLinePrice {
    final double basePrice = product.price ?? 0.0;
    return basePrice * quantity;
  }
}
