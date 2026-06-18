import 'package:flutter/material.dart';
import 'package:freewheel_mart/features/shop/provider/product_provider.dart';
import 'package:provider/provider.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  final List<String> _categories = const [
    'All',
    'Bikes',
    'Components',
    'Gear',
    'Accessories',
  ];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final bool isSelected = productProvider.selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  productProvider.setCategory(category);
                }
              },
              selectedColor: const Color(0xff4B4CED),
              backgroundColor: const Color(0xff242C3B),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.05),
                ),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}
