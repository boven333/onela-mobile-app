import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onelamarket_app/features/orders/presentation/controllers/orders_controller.dart';
import 'package:onelamarket_app/features/shop/presentation/controllers/checkout_controller.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key});

  String _fmtDate(DateTime d) => DateFormat('dd-MM-yyyy').format(d);

  String? _extractOrderId(Object? arg) {
    if (arg == null) return null;

    // ✅ ส่งมาเป็น String
    if (arg is String) return arg;

    // ✅ เผื่อส่งเป็น Map เช่น {'id': '...'}
    if (arg is Map) {
      final v = arg['id'];
      if (v is String) return v;
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final orderId = _extractOrderId(arg);

    debugPrint('OrderDetailPage: orderId=$orderId, argType=${arg.runtimeType}, arg=$arg');

    if (orderId == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Order',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'ไม่พบข้อมูลออเดอร์ (ไม่มี orderId)\n\n'
              'argType: ${arg.runtimeType}\n'
              'arg: $arg\n\n'
              '=> แปลว่า pushNamed มาหน้านี้โดยไม่ได้ส่ง arguments',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
    }

    // ✅ ดึงจาก provider
    final order = ref.read(ordersProvider.notifier).byId(orderId);
    if (order == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Order : $orderId',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ),
        body: const Center(child: Text('ไม่พบออเดอร์นี้ (อาจถูกลบ/ยังไม่ได้สร้าง)')),
      );
    }

    final statusText = switch (order.status) {
      OrderStatus.success => 'สำเร็จ',
      OrderStatus.pending => 'รอดำเนินการ',
      OrderStatus.canceled => 'ยกเลิก',
    };

    final statusColor = switch (order.status) {
      OrderStatus.success => const Color(0xFF16A34A),
      OrderStatus.pending => const Color(0xFFF59E0B),
      OrderStatus.canceled => const Color(0xFFDC2626),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order : ${order.id}',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        children: [
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),

          Row(
            children: [
              const Text('สถานะ', style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(fontWeight: FontWeight.w900, color: statusColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Text('รายละเอียด', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 10),

          _InfoBox(
            icon: Icons.location_on_outlined,
            child: Text(order.addressLine, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 10),

          _InfoBox(
            icon: Icons.calendar_month_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Line('วันที่สั่งซื้อ ${_fmtDate(order.createdAt)}'),
                const SizedBox(height: 6),
                _Line(
                  'วันที่รับสินค้า ${_fmtDate(order.deliveryDate)} (${order.deliveryDateLabel})',
                ),
                const SizedBox(height: 6),
                _Line('เวลารับสินค้า ${order.deliverySlot}'),
              ],
            ),
          ),

          const SizedBox(height: 18),
          const Text('รายการสินค้า', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                for (int i = 0; i < order.lines.length; i++) ...[
                  _OrderItemRow(
                    name: order.lines[i].name,
                    meta:
                        '฿${order.lines[i].price} x ${order.lines[i].qty} = ฿${order.lines[i].lineTotal}',
                    qtyText: 'x${order.lines[i].qty}',
                    isLast: i == order.lines.length - 1,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 18),
          const Text('สรุปยอด', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 10),

          _SummaryBox(
            itemCount: order.itemCount,
            subtotal: order.subtotal,
            shipping: order.shipping,
            vat: order.vat,
            total: order.total,
            paymentMethodText: order.paymentMethod == PaymentMethod.online
                ? 'ชำระเงินออนไลน์'
                : 'เก็บเงินปลายทาง (COD)',
          ),

          const SizedBox(height: 18),
          const Text('เอกสารทั้งหมด', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 10),

          _DocBox(
            iconText: 'INV',
            iconColor: const Color(0xFF2563EB),
            title: 'ใบแจ้งหนี้',
            onDownload: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('ดาวน์โหลด ใบแจ้งหนี้ (mock) — ${order.id}')));
            },
          ),
          const SizedBox(height: 10),
          _DocBox(
            iconText: 'PO',
            iconColor: const Color.fromARGB(255, 255, 40, 40),
            title: 'ใบสั่งซื้อ',
            onDownload: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('ดาวน์โหลด ใบสั่งซื้อ (mock) — ${order.id}')));
            },
          ),
        ],
      ),
    );
  }
}

// ==================== UI ====================

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(width: 10),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w700));
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({
    required this.name,
    required this.meta,
    required this.qtyText,
    required this.isLast,
  });

  final String name;
  final String meta;
  final String qtyText;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(
                    meta,
                    style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              qtyText,
              style: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.w900),
            ),
          ],
        ),
        if (!isLast) const Divider(height: 18, color: Color(0xFFE5E7EB)),
      ],
    );
  }
}

class _SummaryBox extends StatelessWidget {
  const _SummaryBox({
    required this.itemCount,
    required this.subtotal,
    required this.shipping,
    required this.vat,
    required this.total,
    required this.paymentMethodText,
  });

  final int itemCount;
  final int subtotal;
  final int shipping;
  final int vat;
  final int total;
  final String paymentMethodText;

  @override
  Widget build(BuildContext context) {
    Widget row(String left, String right, {bool bold = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                left,
                style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w700),
              ),
            ),
            Text(right, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w700)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          row('วิธีชำระเงิน', paymentMethodText),
          const Divider(height: 18, color: Color(0xFFE5E7EB)),
          row('จำนวน', '$itemCount ชิ้น'),
          row('ยอดสินค้า', '฿$subtotal'),
          row('ค่าส่ง', '฿$shipping'),
          row('VAT', '฿$vat'),
          const Divider(height: 18, color: Color(0xFFE5E7EB)),
          row('รวมทั้งหมด', '฿$total', bold: true),
        ],
      ),
    );
  }
}

class _DocBox extends StatelessWidget {
  const _DocBox({
    required this.iconText,
    required this.iconColor,
    required this.title,
    required this.onDownload,
  });

  final String iconText;
  final Color iconColor;
  final String title;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              iconText,
              style: TextStyle(color: iconColor, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          InkWell(
            onTap: onDownload,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 52,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.download_rounded, color: Color(0xFF047857)),
            ),
          ),
        ],
      ),
    );
  }
}
