import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/features/reorder/presentation/controllers/reorder_history_controller.dart';
import 'package:onelamarket_app/features/shop/domain/models/product.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routing/routes.dart';
import '../../../shop/presentation/controllers/cart_controller.dart';
import '../../../shop/presentation/controllers/catalog_controller.dart';

// ===== PAGE =====
class ReorderPage extends ConsumerWidget {
  const ReorderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(productsProvider); // หรือ MockCatalog.products
    final byId = {for (final p in allProducts) p.id: p};
    final history = ref.watch(reorderHistoryProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCat = ref.watch(selectedCategoryIdProvider);
    final q = ref.watch(searchQueryProvider).trim().toLowerCase();

    final cartItems = ref.watch(cartProvider);
    final cartCount = cartItems.fold<int>(0, (s, x) => s + x.qty);

    int qtyOf(String productId) {
      final idx = cartItems.indexWhere((x) => x.product.id == productId);
      return idx == -1 ? 0 : cartItems[idx].qty;
    }

    // filter: ซ่อนของที่ลบ + search + category
    final items = history.productIds
        .where((id) => !history.hiddenIds.contains(id))
        .map((id) => byId[id])
        .whereType<Product>()
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // header bg
            Container(height: 220, width: double.infinity, color: AppColors.brand),

            Column(
              children: [
                // ===== HEADER =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'สั่งซื้อซ้ำ',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, Routes.profile),
                            icon: const Icon(Icons.person_outline),
                          ),
                          IconButton(
                            onPressed: cartCount == 0
                                ? null
                                : () => Navigator.pushNamed(context, Routes.cart),
                            icon: const Icon(Icons.shopping_cart_outlined),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        height: 50, // ✅ คุมความสูงชัด ๆ (ลอง 38–42 ตามชอบ)
                        child: TextField(
                          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
                          style: const TextStyle(fontSize: 14), // ตัวอักษรเล็กลงนิดนึง
                          decoration: InputDecoration(
                            hintText: 'ค้นหา รายการสินค้า',
                            hintStyle: const TextStyle(fontSize: 14),
                            prefixIcon: const Icon(Icons.search, size: 18),
                            filled: true,
                            fillColor: Colors.white,

                            // 🔥 จุดสำคัญ ลด padding
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // categories row
                      SizedBox(
                        height: 86,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (context, i) {
                            final c = categories[i];
                            final isSel = c.id == selectedCat;

                            return _CategoryItem(
                              label: c.name,
                              iconPath: c.iconPath,
                              selected: isSel,
                              onTap: () =>
                                  ref.read(selectedCategoryIdProvider.notifier).state = c.id,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== LIST (Vertical) =====
                Expanded(
                  child: items.isEmpty
                      ? const _EmptyCartView()
                      : Container(
                          color: Colors.white,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(AppSizes.p16, 8, AppSizes.p16, 120),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const Divider(height: 18),
                            itemBuilder: (context, i) {
                              final p = items[i];
                              final qty = qtyOf(p.id);

                              return _ReorderListTile(
                                productId: p.id,
                                imageAsset: p.imageAsset,
                                title: p.name,
                                subtitle: p.subtitle,
                                price: p.price,
                                qty: qty,
                                onAddFirst: () => ref.read(cartProvider.notifier).add(p),
                                onInc: () => ref.read(cartProvider.notifier).inc(p.id),
                                onDec: () => ref.read(cartProvider.notifier).dec(p.id),
                                onRemove: () {
                                  ref.read(reorderHistoryProvider.notifier).remove(p.id);
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),

            // floating cart
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: SafeArea(
                top: false,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  offset: cartCount > 0 ? Offset.zero : const Offset(0, 1.2),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: cartCount > 0 ? 1 : 0,
                    child: Center(
                      child: SizedBox(
                        width: 240,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brand,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                          ),
                          onPressed: () => Navigator.pushNamed(context, Routes.cart),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart_outlined),
                              const SizedBox(width: 8),
                              Text(
                                '$cartCount',
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== TILE =====
class _ReorderListTile extends StatelessWidget {
  const _ReorderListTile({
    required this.productId,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.qty,
    required this.onAddFirst,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  final String productId;
  final String imageAsset;
  final String title;
  final String subtitle;
  final int price;
  final int qty;

  final VoidCallback onAddFirst;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(productId), // ✅ กันชื่อซ้ำ
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageAsset, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('฿$price', style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ✅ สลับปุ่ม + กับ - qty +
          _AddOrQtyControl(qty: qty, onAddFirst: onAddFirst, onInc: onInc, onDec: onDec),
        ],
      ),
    );
  }
}

// ===== CONTROL (+) -> (- qty +) =====
class _AddOrQtyControl extends StatelessWidget {
  const _AddOrQtyControl({
    required this.qty,
    required this.onAddFirst,
    required this.onInc,
    required this.onDec,
  });

  final int qty;
  final VoidCallback onAddFirst;
  final VoidCallback onInc;
  final VoidCallback onDec;

  @override
  Widget build(BuildContext context) {
    if (qty <= 0) {
      return InkWell(
        onTap: onAddFirst,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleBtn(icon: Icons.remove, onTap: onDec),
        const SizedBox(width: 10),
        Container(
          width: 64,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ),
        const SizedBox(width: 10),
        _CircleBtn(icon: Icons.add, onTap: onInc),
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
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Color(0xFF2F6F61), // เขียวเข้มแบบภาพ
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

// ===== CATEGORY ITEM =====
class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.label,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? iconPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,

            alignment: Alignment.center,
            child: iconPath == null
                ? const Icon(Icons.circle, color: Colors.white, size: 18)
                : SizedBox(
                    width: 46,
                    height: 46,
                    child: Image.asset(iconPath!, fit: BoxFit.contain),
                  ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 56,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.black26),
          SizedBox(height: 12),
          Text(
            'ยังไม่มีรายการสินค้า',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black54),
          ),
          SizedBox(height: 4),
          Text(
            'เพิ่มสินค้าเพื่อเริ่มทำรายการ',
            style: TextStyle(fontSize: 13, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}
