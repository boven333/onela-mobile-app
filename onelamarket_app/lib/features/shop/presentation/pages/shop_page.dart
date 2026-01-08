import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routing/routes.dart';
import '../controllers/cart_controller.dart';
import '../controllers/catalog_controller.dart';
import '../widgets/product_card.dart';

class ShopPage extends ConsumerWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selectedCat = ref.watch(selectedCategoryIdProvider);

    final grouped = ref.watch(productsGroupedProvider);

    final cartItems = ref.watch(cartProvider);
    final cartCount = cartItems.fold<int>(0, (s, x) => s + x.qty);

    // helper: เอาชื่อหมวดจาก id
    String catName(String id) {
      final c = categories.firstWhere((x) => x.id == id, orElse: () => categories.first);
      return c.name;
    }

    // list ของ category ที่จะแสดงเป็น section (ใช้ตอน cat_all)
    final sectionCategoryIds = selectedCat == 'cat_all'
        ? categories.where((c) => c.id != 'cat_all').map((c) => c.id).toList()
        : [selectedCat];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ พื้นหลังสีเฉพาะส่วน header+cat
            Container(height: 230, width: double.infinity, color: AppColors.brand),

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
                              'เชียงใหม่',
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

                      // search
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

                      // Categories row
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

                // ===== PRODUCTS =====
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: selectedCat == 'cat_all'
                        // ✅ ALL => section + horizontal slider (เหมือนเดิม)
                        ? ListView.builder(
                            padding: const EdgeInsets.only(bottom: 120),
                            itemCount: sectionCategoryIds.length,
                            itemBuilder: (context, index) {
                              final catId = sectionCategoryIds[index];
                              final items = grouped[catId] ?? const [];
                              if (items.isEmpty) return const SizedBox.shrink();

                              return _Section(title: catName(catId), products: items);
                            },
                          )
                        // ✅ Selected Category => 2-column grid (ตามที่มึงต้องการ)
                        : _SingleCategoryGrid(products: grouped[selectedCat] ?? const []),
                  ),
                ),
              ],
            ),

            // ===== Floating cart button =====
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

// ===================== ALL CATEGORY SECTION (horizontal) =====================

class _Section extends ConsumerWidget {
  const _Section({required this.title, required this.products});

  final String title;
  final List products; // Product

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final p = products[i];
                return SizedBox(
                  width: 160,
                  child: ProductCard(
                    productId: p.id,
                    imageAsset: p.imageAsset,
                    title: p.name,
                    subtitle: p.subtitle,
                    priceText: '฿${p.price}',
                    onAddFirst: () => ref.read(cartProvider.notifier).add(p),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== SINGLE CATEGORY GRID (2 columns) =====================

class _SingleCategoryGrid extends ConsumerWidget {
  const _SingleCategoryGrid({required this.products});

  final List products; // Product

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (products.isEmpty) {
      return const Center(
        child: Text('ยังไม่มีสินค้าในหมวดนี้', style: TextStyle(fontWeight: FontWeight.w700)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(AppSizes.p16, 10, AppSizes.p16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78, // ปรับได้ตามการ์ดของมึง
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final p = products[i];
        return ProductCard(
          productId: p.id,
          imageAsset: p.imageAsset,
          title: p.name,
          subtitle: p.subtitle,
          priceText: '฿${p.price}',
          onAddFirst: () => ref.read(cartProvider.notifier).add(p),
        );
      },
    );
  }
}

// ===================== CATEGORY ITEM =====================

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
            decoration: const BoxDecoration(shape: BoxShape.circle),
            alignment: Alignment.center,
            child: iconPath == null
                ? const Icon(Icons.circle, color: Colors.white, size: 18)
                : SizedBox(
                    width: 46,
                    height: 46,
                    child: ClipOval(child: Image.asset(iconPath!, fit: BoxFit.cover)),
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
