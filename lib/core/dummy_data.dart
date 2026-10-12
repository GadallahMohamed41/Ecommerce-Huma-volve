import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<Color> colors;
  final List<String> sizes;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.colors,
    required this.sizes,
    this.category = 'General',
  });
}

final dummyProducts = [
  Product(
    id: '1',
    name: 'Classic White Sneakers',
    description: 'Premium minimalist white leather sneakers with cushioned insole for all-day comfort.',
    price: 59.99,
    imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=600&q=80',
    colors: [Colors.white, Colors.black, Colors.grey],
    sizes: ['40', '41', '42', '43'],
    category: 'Shoes',
  ),
  Product(
    id: '2',
    name: 'Denim Jacket',
    description: 'Timeless vintage blue denim jacket crafted from durable cotton with brass buttons.',
    price: 89.99,
    imageUrl: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=600&q=80',
    colors: [Colors.blue, Colors.black],
    sizes: ['S', 'M', 'L', 'XL'],
    category: 'Clothing',
  ),
  Product(
    id: '3',
    name: 'Wireless Headphones',
    description: 'Active noise-canceling over-ear wireless headphones with studio-quality audio and 30-hour battery life.',
    price: 199.99,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80',
    colors: [Colors.black, Colors.grey],
    sizes: ['One Size'],
    category: 'Electronics',
  ),
  Product(
    id: '4',
    name: 'Smart Watch',
    description: 'Sleek fitness smartwatch featuring heart rate monitor, AMOLED display, and water resistance.',
    price: 149.99,
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
    colors: [Colors.black, Colors.blue, Colors.pink],
    sizes: ['One Size'],
    category: 'Electronics',
  ),
  Product(
    id: '5',
    name: 'Running Sports Shoes',
    description: 'Ultra-lightweight athletic running shoes engineered for breathable comfort and high responsiveness.',
    price: 79.99,
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80',
    colors: [Colors.red, Colors.black, Colors.white],
    sizes: ['40', '41', '42', '43', '44'],
    category: 'Shoes',
  ),
  Product(
    id: '6',
    name: 'Cozy Fleece Hoodie',
    description: 'Relaxed fit pullover hoodie with soft brushed fleece interior and kangaroo pocket.',
    price: 64.99,
    imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=600&q=80',
    colors: [Colors.grey, Colors.black, Colors.blueGrey],
    sizes: ['S', 'M', 'L', 'XL'],
    category: 'Clothing',
  ),
  Product(
    id: '7',
    name: 'Classic Aviator Sunglasses',
    description: 'Iconic polarized metal-frame aviator sunglasses with 100% UV400 protection.',
    price: 45.00,
    imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=600&q=80',
    colors: [Colors.black, const Color(0xFFB8860B)],
    sizes: ['One Size'],
    category: 'Accessories',
  ),
  Product(
    id: '8',
    name: 'Leather Travel Backpack',
    description: 'Handcrafted genuine leather backpack with dedicated 15-inch laptop sleeve and antique brass hardware.',
    price: 129.99,
    imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=600&q=80',
    colors: [const Color(0xFF8B4513), Colors.black],
    sizes: ['One Size'],
    category: 'Accessories',
  ),
];

class CartItem {
  final Product product;
  final int quantity;
  final Color selectedColor;
  final String selectedSize;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
    Color? selectedColor,
    String? selectedSize,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }
}

final List<CartItem> dummyCart = [];

class UserProfile {
  final String name;
  final String email;
  final String profilePictureUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.profilePictureUrl,
  });
}

final dummyUser = UserProfile(
  name: 'John Doe',
  email: 'john.doe@example.com',
  profilePictureUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
);

final dummyCategories = [
  'All',
  'Shoes',
  'Clothing',
  'Accessories',
  'Electronics',
];
