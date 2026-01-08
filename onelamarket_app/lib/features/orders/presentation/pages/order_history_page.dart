import 'package:flutter/material.dart';

import '../../../../core/routing/routes.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ===== MOCK =====
    final orders = [
      _OrderHistoryItem(
        code: 'CO-20263281426',
        date: '07/01/2026',
        itemCountText: '2 รายการ',
        totalText: 'ยอดสุทธิ ฿1,429.00',
        statusText: 'ยกเลิก',
        statusColor: const Color(0xFFDC2626),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: const [
            Icon(Icons.access_time, color: Colors.black87),
            SizedBox(width: 10),
            Text(
              'ประวัติออเดอร์',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final o = orders[i];
          return _OrderHistoryCard(
            item: o,
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.orderDetail,
                arguments: o.code, // ส่ง code ไปหน้ารายละเอียด (optional)
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderHistoryItem {
  final String code;
  final String date;
  final String itemCountText;
  final String totalText;
  final String statusText;
  final Color statusColor;

  _OrderHistoryItem({
    required this.code,
    required this.date,
    required this.itemCountText,
    required this.totalText,
    required this.statusText,
    required this.statusColor,
  });
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({required this.item, required this.onTap});

  final _OrderHistoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order: ${item.code}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.itemCountText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.totalText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.statusText,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: item.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                item.date,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
