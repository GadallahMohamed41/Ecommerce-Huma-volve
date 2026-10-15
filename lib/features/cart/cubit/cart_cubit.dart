import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/dummy_data.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  static CartCubit _instance = CartCubit.create();
  static CartCubit get instance => _instance;

  factory CartCubit() => _instance;

  final List<CartItem> _items;

  CartCubit.create([List<CartItem>? initialItems])
      : _items = List<CartItem>.from(initialItems ?? dummyCart),
        super(CartInitialState(List<CartItem>.from(initialItems ?? dummyCart)));

  @visibleForTesting
  static void resetForTesting() {
    _instance = CartCubit.create([]);
  }

  List<CartItem> get items => state.items;

  int get totalItemsCount => state.totalQuantity;

  void addToCart({
    required Product product,
    int quantity = 1,
    Color? selectedColor,
    String? selectedSize,
  }) {
    final color = selectedColor ??
        (product.colors.isNotEmpty ? product.colors.first : Colors.black);
    final size = selectedSize ??
        (product.sizes.isNotEmpty ? product.sizes.first : 'One Size');

    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor.toARGB32() == color.toARGB32(),
    );

    if (existingIndex != -1) {
      final current = _items[existingIndex];
      _items[existingIndex] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    } else {
      _items.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedColor: color,
          selectedSize: size,
        ),
      );
    }

    _syncAndEmit();
  }

  void removeFromCart(CartItem cartItem) {
    _items.removeWhere(
      (item) =>
          item.product.id == cartItem.product.id &&
          item.selectedSize == cartItem.selectedSize &&
          item.selectedColor.toARGB32() == cartItem.selectedColor.toARGB32(),
    );
    _syncAndEmit();
  }

  void incrementQuantity(CartItem cartItem) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == cartItem.product.id &&
          item.selectedSize == cartItem.selectedSize &&
          item.selectedColor.toARGB32() == cartItem.selectedColor.toARGB32(),
    );

    if (index != -1) {
      final current = _items[index];
      _items[index] = current.copyWith(quantity: current.quantity + 1);
      _syncAndEmit();
    }
  }

  void decrementQuantity(CartItem cartItem) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == cartItem.product.id &&
          item.selectedSize == cartItem.selectedSize &&
          item.selectedColor.toARGB32() == cartItem.selectedColor.toARGB32(),
    );

    if (index != -1) {
      final current = _items[index];
      if (current.quantity > 1) {
        _items[index] = current.copyWith(quantity: current.quantity - 1);
      } else {
        _items.removeAt(index);
      }
      _syncAndEmit();
    }
  }

  void clearCart() {
    _items.clear();
    _syncAndEmit();
  }

  void _syncAndEmit() {
    if (identical(this, _instance)) {
      dummyCart.clear();
      dummyCart.addAll(_items);
    }
    emit(CartUpdatedState(List<CartItem>.unmodifiable(_items)));
  }
}
