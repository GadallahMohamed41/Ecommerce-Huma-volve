import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../network/api_client.dart';

class ProductApiService {
  static final ProductApiService _instance = ProductApiService._internal();
  factory ProductApiService() => _instance;

  final ApiClient _apiClient = ApiClient();

  ProductApiService._internal();

  String _sanitizeImageUrl(dynamic imageRaw, String fallback) {
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

  String _mapCategory(String? apiCat) {
    if (apiCat == null) return 'General';
    final lower = apiCat.toLowerCase();
    if (lower.contains('shoe')) return 'Shoes';
    if (lower.contains('cloth')) return 'Clothing';
    if (lower.contains('electronic')) return 'Electronics';
    return 'Accessories';
  }

  Future<List<Product>> fetchProducts({int offset = 0, int limit = 10}) async {
    try {
      final response = await _apiClient.dio.get(
        '/products',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      if (response.statusCode == 200 && response.data is List) {
        final List rawList = response.data;
        final List<Product> parsed = [];

        for (var item in rawList) {
          if (item is! Map<String, dynamic>) continue;
          final title = item['title']?.toString() ?? '';
          if (title.startsWith('title-') || title.isEmpty) continue;

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

          parsed.add(
            Product(
              id: id,
              name: title,
              description: desc,
              price: price,
              imageUrl: imageUrl,
              colors: [Colors.black, Colors.blueGrey, Colors.brown],
              sizes: ['S', 'M', 'L', 'XL'],
              category: category,
            ),
          );
        }

        if (parsed.isNotEmpty) {
          return parsed;
        }
      }
    } on DioException catch (e) {
      debugPrint('ProductApiService: Dio error fetching products: ${e.message}');
    } catch (e) {
      debugPrint('ProductApiService: Error fetching products: $e');
    }

    return dummyProducts;
  }
}
