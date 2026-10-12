import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/dummy_data.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  static final CartCubit instance = CartCubit._internal();

  factory CartCubit() => instance;

  CartCubit._internal() : super(CartInitialState(List<CartItem>.from(dummyCart)));

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

    final existingIndex = dummyCart.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor.toARGB32() == color.toARGB32(),
    );

    if (existingIndex != -1) {
      final current = dummyCart[existingIndex];
      dummyCart[existingIndex] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    } else {
      dummyCart.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedColor: color,
          selectedSize: size,
        ),
      );
    }

    emit(CartUpdatedState(List<CartItem>.from(dummyCart)));
  }

  void removeFromCart(CartItem cartItem) {
    dummyCart.removeWhere(
      (item) =>
          item.product.id == cartItem.product.id &&
          item.selectedSize == cartItem.selectedSize &&
          item.selectedColor.toARGB32() == cartItem.selectedColor.toARGB32(),
    );
    emit(CartUpdatedState(List<CartItem>.from(dummyCart)));
  }

  void incrementQuantity(CartItem cartItem) {
    final index = dummyCart.indexWhere(
      (item) =>
          item.product.id == cartItem.product.id &&
          item.selectedSize == cartItem.selectedSize &&
          item.selectedColor.toARGB32() == cartItem.selectedColor.toARGB32(),
    );

    if (index != -1) {
      final current = dummyCart[index];
      dummyCart[index] = current.copyWith(quantity: current.quantity + 1);
      emit(CartUpdatedState(List<CartItem>.from(dummyCart)));
    }
  }

  void decrementQuantity(CartItem cartItem) {
    final index = dummyCart.indexWhere(
      (item) =>
          item.product.id == cartItem.product.id &&
          item.selectedSize == cartItem.selectedSize &&
          item.selectedColor.toARGB32() == cartItem.selectedColor.toARGB32(),
    );

    if (index != -1) {
      final current = dummyCart[index];
      if (current.quantity > 1) {
        dummyCart[index] = current.copyWith(quantity: current.quantity - 1);
      } else {
        dummyCart.removeAt(index);
      }
      emit(CartUpdatedState(List<CartItem>.from(dummyCart)));
    }
  }

  void clearCart() {
    dummyCart.clear();
    emit(CartUpdatedState(const []));
  }
}
