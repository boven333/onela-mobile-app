import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/features/orders/presentation/controllers/orders_controller.dart';
import 'package:onelamarket_app/features/reorder/presentation/controllers/reorder_history_controller.dart';
import 'package:onelamarket_app/features/shop/presentation/sheet/address_form_sheet.dart';
import 'package:onelamarket_app/features/shop/presentation/sheet/delivery_time_sheet.dart';
import 'package:onelamarket_app/features/shop/presentation/sheet/payment_method_sheet.dart';

import '../../../../core/constants/app_colors.dart';
import '../controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCtrl = ref.read(cartProvider.notifier);
    final items = ref.watch(cartProvider);
    final subtotal = cartCtrl.subtotal;

    // mock fees
    final shipping = items.isEmpty ? 0 : 0;
    final vat = 0;
    final total = subtotal + shipping + vat;

    final checkout = ref.watch(checkoutProvider);
    final checkoutCtrl = ref.read(checkoutProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 22),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('จัดส่งไปที่', style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            _card(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      checkout.addressLine,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) =>
                            AddressFormSheet(onSave: (addr) => checkoutCtrl.setAddress(addr)),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            _card(
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'วันและเวลา: ${checkout.deliverySlot}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => DeliveryTimeSheet(
                          initialDate: checkout.deliveryDate,
                          initialSlot: checkout.deliverySlot,
                          onSelect: (date, dateLabel, slot) {
                            checkoutCtrl.setDeliveryDateTime(date, dateLabel, slot);
                          },
                        ),
                      );
                    },
                    child: const Text('เปลี่ยน'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            const Text('สรุป', style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            _summaryRow('จำนวน', '${items.length} ชิ้น'),
            _summaryRow('ค่าส่ง', '฿$shipping'),
            _summaryRow('VAT (0%)', '฿$vat'),
            const Divider(),
            _summaryRow('รวมทั้งหมด', '฿$total', bold: true),

            const SizedBox(height: 18),
            const Text('ชำระด้วย', style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            _card(
              child: Row(
                children: [
                  const Icon(Icons.credit_card),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      checkout.method == PaymentMethod.online
                          ? 'ชำระเงินออนไลน์'
                          : 'เก็บเงินปลายทาง (COD)',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) =>
                            PaymentMethodSheet(onSelect: (m) => checkoutCtrl.setPayment(m)),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              onPressed: items.isEmpty
                  ? null
                  : () {
                      // 1) เก็บ reorder history (ของเดิม)
                      final orderedIds = ref.read(cartProvider).map((x) => x.product.id).toList();
                      ref.read(reorderHistoryProvider.notifier).addOrder(orderedIds);

                      // 2) ✅ สร้าง Order จริงจาก cart + checkout
                      final order = ref
                          .read(ordersProvider.notifier)
                          .createFromCheckout(
                            cartItems: ref.read(cartProvider),
                            checkout: ref.read(checkoutProvider),
                          );

                      // 3) แจ้ง success
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('สั่งซื้อสำเร็จ (mock) — ${order.id}')),
                      );

                      // 4) เคลียร์ตะกร้า
                      cartCtrl.clear();

                      // 5) กลับ
                      Navigator.pop(context);
                    },
              child: const Text(
                'ดำเนินการ',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500),
            ),
          ),
          Text(right, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
