import 'package:flutter/material.dart';
import '../../../../core/dummy_data.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.colors,
    required super.sizes,
    super.category,
  });

  static String _sanitizeImageUrl(dynamic imageRaw, String fallback) {
    if (imageRaw == null) return fallback;
    String str = imageRaw.toString().trim();
    str = str.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').replaceAll("'", '').trim();
    if (!str.startsWith('http://') && !str.startsWith('https://')) {
      return fallback;
    }
    if (str.contains('placehold.co') || str.contains('placeholder')) {
      return fallback;
    }
    return str;
  }

  static String _mapCategory(String? apiCat) {
    if (apiCat == null) return 'General';
    final lower = apiCat.toLowerCase();
    if (lower.contains('shoe')) return 'Shoes';
    if (lower.contains('cloth')) return 'Clothing';
    if (lower.contains('electronic')) return 'Electronics';
    return 'Accessories';
  }

  factory ProductModel.fromJson(Map<String, dynamic> item) {
    final title = item['title']?.toString() ?? 'Product';
    final id = item['id']?.toString() ?? UniqueKey().toString();
    final desc = item['description']?.toString() ?? 'High quality product.';
    final num priceNum = item['price'] is num ? item['price'] : 49.99;
    final double price = priceNum.toDouble();

    final images = item['images'];
    dynamic firstImg;
    if (images is List && images.isNotEmpty) {
      firstImg = images.first;
    }

    final categoryObj = item['category'];
    final categoryName = categoryObj is Map ? categoryObj['name']?.toString() : null;
    final category = _mapCategory(categoryName);

    final fallbackMatch = dummyProducts.firstWhere(
      (p) => p.category.toLowerCase() == category.toLowerCase(),
      orElse: () => dummyProducts.first,
    ).imageUrl;

    final imageUrl = _sanitizeImageUrl(firstImg, fallbackMatch);

    return ProductModel(
      id: id,
      name: title,
      description: desc,
      price: price,
      imageUrl: imageUrl,
      colors: [Colors.black, Colors.blueGrey, Colors.brown],
      sizes: ['S', 'M', 'L', 'XL'],
      category: category,
    );
  }
}
