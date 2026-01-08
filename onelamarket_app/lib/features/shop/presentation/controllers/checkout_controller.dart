import 'package:flutter_riverpod/legacy.dart';

enum PaymentMethod { online, cod }

class CheckoutState {
  final String addressLine;
  final PaymentMethod method;

  // ✅ ของจริง (ไว้ส่ง API)
  final DateTime deliveryDate;

  // ✅ ไว้โชว์ UI ตามดีไซน์ (เช่น "อ. 23")
  final String deliveryDateLabel;

  // ✅ ช่วงเวลา (เช่น "10.00 - 12.00")
  final String deliverySlot;

  CheckoutState({
    this.addressLine = '999/1 หมู่ 1 เชียงใหม่, เชียงใหม่',
    this.method = PaymentMethod.online,
    DateTime? deliveryDate,
    this.deliveryDateLabel = 'อ. 23',
    this.deliverySlot = '10.00 - 12.00',
  }) : deliveryDate = deliveryDate ?? DateTime.now();

  CheckoutState copyWith({
    String? addressLine,
    PaymentMethod? method,
    DateTime? deliveryDate,
    String? deliveryDateLabel,
    String? deliverySlot,
  }) {
    return CheckoutState(
      addressLine: addressLine ?? this.addressLine,
      method: method ?? this.method,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryDateLabel: deliveryDateLabel ?? this.deliveryDateLabel,
      deliverySlot: deliverySlot ?? this.deliverySlot,
    );
  }
}

final checkoutProvider = StateNotifierProvider<CheckoutController, CheckoutState>(
  (ref) => CheckoutController(),
);

class CheckoutController extends StateNotifier<CheckoutState> {
  CheckoutController() : super(CheckoutState());

  void setPayment(PaymentMethod m) => state = state.copyWith(method: m);
  void setAddress(String addr) => state = state.copyWith(addressLine: addr);

  // ✅ set วันจริง + label + slot พร้อมกัน (ใช้กับ DeliveryTimeSheet ใหม่)
  void setDeliveryDateTime(DateTime date, String dateLabel, String slot) {
    state = state.copyWith(deliveryDate: date, deliveryDateLabel: dateLabel, deliverySlot: slot);
  }

  // (ถ้าต้องการอัปเดตแค่ slot เฉย ๆ ก็เพิ่มได้)
  void setDeliverySlot(String slot) => state = state.copyWith(deliverySlot: slot);
}
