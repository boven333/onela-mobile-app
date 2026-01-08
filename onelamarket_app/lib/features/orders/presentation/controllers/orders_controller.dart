import 'package:flutter_riverpod/legacy.dart';
import 'package:onelamarket_app/features/shop/domain/models/cart_item.dart';
import 'package:onelamarket_app/features/shop/presentation/controllers/checkout_controller.dart';

enum OrderStatus { pending, success, canceled }

class OrderLine {
  final String productId;
  final String name;
  final int price;
  final int qty;
  final String imageAsset;

  const OrderLine({
    required this.productId,
    required this.name,
    required this.price,
    required this.qty,
    required this.imageAsset,
  });

  int get lineTotal => price * qty;
}

class OrderEntity {
  final String id; // เช่น OC-20260108-0001
  final DateTime createdAt;
  final OrderStatus status;

  final String addressLine;
  final PaymentMethod paymentMethod;

  final DateTime deliveryDate; // ของจริง
  final String deliveryDateLabel; // ไว้โชว์
  final String deliverySlot;

  final List<OrderLine> lines;

  const OrderEntity({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.addressLine,
    required this.paymentMethod,
    required this.deliveryDate,
    required this.deliveryDateLabel,
    required this.deliverySlot,
    required this.lines,
  });

  int get itemCount => lines.fold(0, (s, x) => s + x.qty);
  int get subtotal => lines.fold(0, (s, x) => s + x.lineTotal);
  int get shipping => lines.isEmpty ? 0 : 0; // mock
  int get vat => 0; // mock
  int get total => subtotal + shipping + vat;
}

class OrdersState {
  final List<OrderEntity> orders; // ใหม่สุดอยู่บน
  const OrdersState({this.orders = const []});

  OrdersState copyWith({List<OrderEntity>? orders}) => OrdersState(orders: orders ?? this.orders);
}

final ordersProvider = StateNotifierProvider<OrdersController, OrdersState>(
  (ref) => OrdersController(),
);

class OrdersController extends StateNotifier<OrdersState> {
  OrdersController() : super(const OrdersState());

  // สร้างรหัสออเดอร์แบบง่าย ๆ (พอสำหรับ MVP)
  String _newOrderId() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final seq = (state.orders.length + 1).toString().padLeft(4, '0');
    return 'OC-$y$m$d-$seq';
  }

  OrderEntity createFromCheckout({
    required List<CartItem> cartItems,
    required CheckoutState checkout,
  }) {
    final id = _newOrderId();

    final lines = cartItems
        .map(
          (x) => OrderLine(
            productId: x.product.id,
            name: x.product.name,
            price: x.product.price,
            qty: x.qty,
            imageAsset: x.product.imageAsset,
          ),
        )
        .toList();

    final order = OrderEntity(
      id: id,
      createdAt: DateTime.now(),
      status: OrderStatus.success, // mock: จ่ายสำเร็จเลย
      addressLine: checkout.addressLine,
      paymentMethod: checkout.method,
      deliveryDate: checkout.deliveryDate,
      deliveryDateLabel: checkout.deliveryDateLabel,
      deliverySlot: checkout.deliverySlot,
      lines: lines,
    );

    // push เข้า list (ใหม่สุดอยู่บน)
    state = state.copyWith(orders: [order, ...state.orders]);
    return order;
  }

  OrderEntity? byId(String id) {
    for (final o in state.orders) {
      if (o.id == id) return o;
    }
    return null;
  }
}
