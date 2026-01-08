import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../controllers/cart_controller.dart';
import 'add_or_qty_control.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.productId,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.priceText,
    required this.onAddFirst,
  });

  final String productId;
  final String imageAsset;
  final String title;
  final String? subtitle;
  final String priceText;

  /// กดครั้งแรกให้ add เข้าตะกร้า (qty จาก 0 -> 1)
  final VoidCallback onAddFirst;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final idx = cartItems.indexWhere((x) => x.product.id == productId);
    final qty = idx == -1 ? 0 : cartItems[idx].qty;

    return Container(
      padding: const EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(child: Image.asset(imageAsset, fit: BoxFit.contain)),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
              const SizedBox(height: 6),
              Text(priceText, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),

          // ✅ มุมขวาบน: + หรือ - qty +
          Positioned(
            top: 8,
            right: 8,
            child: AddOrQtyControl(productId: productId, qty: qty, onAddFirst: onAddFirst),
          ),
        ],
      ),
    );
  }
}
