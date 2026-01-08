import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cart_controller.dart';

class AddOrQtyControl extends ConsumerWidget {
  const AddOrQtyControl({
    super.key,
    required this.productId,
    required this.qty,
    required this.onAddFirst,
  });

  final String productId;
  final int qty;
  final VoidCallback onAddFirst;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (qty <= 0) {
      // ✅ ยังไม่มีในตะกร้า => ปุ่ม +
      return InkWell(
        onTap: onAddFirst,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    }

    // ✅ มีแล้ว => - qty +
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleBtn(icon: Icons.remove, onTap: () => ref.read(cartProvider.notifier).dec(productId)),
        const SizedBox(width: 10),
        Container(
          width: 40,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ),
        const SizedBox(width: 10),
        _CircleBtn(icon: Icons.add, onTap: () => ref.read(cartProvider.notifier).inc(productId)),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Color(0xFF2F6F61), // เขียวเข้มแบบในภาพ
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
