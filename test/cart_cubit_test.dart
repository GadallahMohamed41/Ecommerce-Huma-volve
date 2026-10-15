import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app_huma_volve/core/dummy_data.dart';
import 'package:ecommerce_app_huma_volve/features/cart/cubit/cart_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/cart/cubit/cart_state.dart';

void main() {
  group('CartCubit', () {
    final testProduct = Product(
      id: 'test-1',
      name: 'Test Sneaker',
      description: 'A test product',
      price: 100.0,
      imageUrl: 'https://example.com/test.jpg',
      colors: [Colors.black, Colors.white],
      sizes: ['41', '42'],
      category: 'Shoes',
    );

    test('initial state has empty items', () {
      final cubit = CartCubit.create([]);
      expect(cubit.state.items, isEmpty);
      expect(cubit.totalItemsCount, 0);
      expect(cubit.state.total, 0.0);
    });

    blocTest<CartCubit, CartState>(
      'emits CartUpdatedState when addToCart is called',
      build: () => CartCubit.create([]),
      act: (cubit) => cubit.addToCart(
        product: testProduct,
        quantity: 1,
        selectedColor: Colors.black,
        selectedSize: '42',
      ),
      expect: () => [
        isA<CartUpdatedState>()
            .having((s) => s.items.length, 'items.length', 1)
            .having((s) => s.items.first.product.name, 'name', 'Test Sneaker')
            .having((s) => s.subtotal, 'subtotal', 100.0)
            .having((s) => s.tax, 'tax', 10.0)
            .having((s) => s.total, 'total', 110.0),
      ],
    );

    blocTest<CartCubit, CartState>(
      'increments quantity when same product with same size/color is added again',
      build: () => CartCubit.create([
        CartItem(
          product: testProduct,
          quantity: 1,
          selectedColor: Colors.black,
          selectedSize: '42',
        ),
      ]),
      act: (cubit) => cubit.addToCart(
        product: testProduct,
        quantity: 2,
        selectedColor: Colors.black,
        selectedSize: '42',
      ),
      expect: () => [
        isA<CartUpdatedState>()
            .having((s) => s.items.length, 'items.length', 1)
            .having((s) => s.items.first.quantity, 'quantity', 3)
            .having((s) => s.subtotal, 'subtotal', 300.0),
      ],
    );

    blocTest<CartCubit, CartState>(
      'decrements quantity and removes item when quantity reaches 0',
      build: () {
        final cubit = CartCubit.create([]);
        cubit.addToCart(
          product: testProduct,
          quantity: 1,
          selectedColor: Colors.black,
          selectedSize: '42',
        );
        return cubit;
      },
      act: (cubit) => cubit.decrementQuantity(cubit.state.items.first),
      expect: () => [
        isA<CartUpdatedState>()
            .having((s) => s.items, 'items', isEmpty)
            .having((s) => s.total, 'total', 0.0),
      ],
    );

    blocTest<CartCubit, CartState>(
      'clears cart when clearCart is called',
      build: () {
        final cubit = CartCubit.create([]);
        cubit.addToCart(
          product: testProduct,
          quantity: 2,
        );
        return cubit;
      },
      act: (cubit) => cubit.clearCart(),
      expect: () => [
        isA<CartUpdatedState>().having((s) => s.items, 'items', isEmpty),
      ],
    );
  });
}
