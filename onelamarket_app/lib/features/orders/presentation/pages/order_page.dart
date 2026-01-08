import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/features/orders/presentation/controllers/orders_controller.dart';

import '../../../../core/routing/routes.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider).orders;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // ✅ เอาลูกศรกลับออกชัวร์
        title: const Text(
          'Order',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('ยังไม่มีคำสั่งซื้อ', style: TextStyle(fontWeight: FontWeight.w800)),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final o = orders[i];
                return _OrderSummaryCard(
                  id: o.id,
                  itemCount: o.itemCount,
                  total: o.total,
                  status: o.status,
                  onTap: () {
                    debugPrint('OrdersPage -> push detail id=${o.id}');
                    Navigator.pushNamed(
                      context,
                      Routes.orderDetail,
                      arguments: o.id, // ✅ ต้องมีบรรทัดนี้
                    );
                  },
                );
              },
            ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.id,
    required this.itemCount,
    required this.total,
    required this.status,
    required this.onTap,
  });

  final String id;
  final int itemCount;
  final int total;
  final OrderStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusText = switch (status) {
      OrderStatus.success => 'สำเร็จ',
      OrderStatus.canceled => 'ยกเลิก',
      OrderStatus.pending => 'รอดำเนินการ',
    };

    final statusColor = switch (status) {
      OrderStatus.success => const Color(0xFF16A34A),
      OrderStatus.canceled => const Color(0xFFDC2626),
      OrderStatus.pending => const Color(0xFFF59E0B),
    };

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order: $id', style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(
                '$itemCount รายการ',
                style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'ยอดสุทธิ ฿$total',
                style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                statusText,
                style: TextStyle(fontWeight: FontWeight.w900, color: statusColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
