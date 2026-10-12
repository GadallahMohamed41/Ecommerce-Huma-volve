import '../../../core/dummy_data.dart';

abstract class CartState {
  final List<CartItem> items;

  const CartState(this.items);

  double get subtotal => items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get tax => subtotal * 0.1;

  double get total => subtotal + tax;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartInitialState extends CartState {
  const CartInitialState(super.items);
}

class CartUpdatedState extends CartState {
  const CartUpdatedState(super.items);
}
