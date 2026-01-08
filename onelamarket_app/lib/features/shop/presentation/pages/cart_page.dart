import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routing/routes.dart';
import '../../data/mock/mock_catalog.dart';
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/qty_stepper.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final cartCtrl = ref.read(cartProvider.notifier);
    final subtotal = cartCtrl.subtotal;

    final upsell = MockCatalog.products.take(4).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 22),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.p16),
          children: [
            ...items.map((x) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.fieldBorder),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(x.product.imageAsset),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(x.product.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(
                            '฿${x.product.price}',
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    QtyStepper(
                      qty: x.qty,
                      onMinus: () => cartCtrl.setQty(x.product, x.qty - 1),
                      onPlus: () => cartCtrl.setQty(x.product, x.qty + 1),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),
            const Text(
              'สินค้าเพิ่มเติม',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              itemCount: upsell.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.80,
              ),
              itemBuilder: (context, i) {
                final p = upsell[i];
                return ProductCard(
                  productId: p.id,
                  imageAsset: p.imageAsset,
                  title: p.name,
                  subtitle: p.subtitle,
                  priceText: '฿${p.price}',
                  onAddFirst: () => ref.read(cartProvider.notifier).add(p),
                );
              },
            ),

            const SizedBox(height: 80),
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
              onPressed: items.isEmpty ? null : () => Navigator.pushNamed(context, Routes.checkout),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'ชำระเงิน',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  Text('฿$subtotal', style: const TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
