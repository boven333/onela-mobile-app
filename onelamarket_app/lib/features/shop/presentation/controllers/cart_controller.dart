import 'package:flutter_riverpod/legacy.dart';

import '../../domain/models/cart_item.dart';
import '../../domain/models/product.dart';

final cartProvider = StateNotifierProvider<CartController, List<CartItem>>(
  (ref) => CartController(),
);

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super(const []);

  // void add(Product p) {
  //   final idx = state.indexWhere((x) => x.product.id == p.id);
  //   if (idx == -1) {
  //     state = [...state, CartItem(product: p, qty: 1)];
  //   } else {
  //     final updated = [...state];
  //     updated[idx] = updated[idx].copyWith(qty: updated[idx].qty + 1);
  //     state = updated;
  //   }
  // }

  void setQty(Product p, int qty) {
    if (qty <= 0) {
      remove(p);
      return;
    }
    final idx = state.indexWhere((x) => x.product.id == p.id);
    if (idx == -1) return;
    final updated = [...state];
    updated[idx] = updated[idx].copyWith(qty: qty);
    state = updated;
  }

  void remove(Product p) {
    state = state.where((x) => x.product.id != p.id).toList();
  }

  void clear() => state = const [];

  int get totalItems => state.fold(0, (s, x) => s + x.qty);
  int get subtotal => state.fold(0, (s, x) => s + x.lineTotal);

  void add(Product p) {
    final list = [...state];
    final idx = list.indexWhere((x) => x.product.id == p.id);
    if (idx == -1) {
      list.add(CartItem(product: p, qty: 1));
    } else {
      list[idx] = list[idx].copyWith(qty: list[idx].qty + 1);
    }
    state = list;
  }

  void inc(String productId) {
    final list = [...state];
    final idx = list.indexWhere((x) => x.product.id == productId);
    if (idx == -1) return;
    list[idx] = list[idx].copyWith(qty: list[idx].qty + 1);
    state = list;
  }

  void dec(String productId) {
    final list = [...state];
    final idx = list.indexWhere((x) => x.product.id == productId);
    if (idx == -1) return;

    final nextQty = list[idx].qty - 1;
    if (nextQty <= 0) {
      list.removeAt(idx);
    } else {
      list[idx] = list[idx].copyWith(qty: nextQty);
    }
    state = list;
  }
}
