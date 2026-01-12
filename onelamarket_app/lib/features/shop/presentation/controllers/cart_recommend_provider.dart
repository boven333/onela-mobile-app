import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/features/shop/domain/models/product.dart';
import 'package:onelamarket_app/features/shop/presentation/controllers/cart_controller.dart';
import 'package:onelamarket_app/features/shop/presentation/controllers/catalog_controller.dart';

final cartRecommendProvider = Provider<List<Product>>((ref) {
  final all = ref.watch(productsProvider); // catalog ทั้งหมด
  final cart = ref.watch(cartProvider); // ของในตะกร้า
  if (all.isEmpty) return const [];

  final cartIds = cart.map((x) => x.product.id).toSet();
  final cartProducts = cart.map((x) => x.product).toList();

  // ถ้าตะกร้าว่าง: สุ่มล้วน ๆ
  if (cartProducts.isEmpty) {
    final pool = all.where((p) => !cartIds.contains(p.id)).toList();
    pool.shuffle(Random());
    return pool.take(4).toList();
  }

  // 1) นับน้ำหนักตามหมวด (ยิ่งอยู่ในตะกร้าเยอะ ยิ่งมีน้ำหนัก)
  final Map<String, int> weightByCat = {};
  for (final c in cart) {
    final catId = c.product.categoryId; // <-- ให้ตรงกับ field ของ Product มึง (อาจชื่อ catId)
    weightByCat[catId] = (weightByCat[catId] ?? 0) + c.qty;
  }

  // 2) ทำ pool ที่ไม่อยู่ในตะกร้า
  final pool = all.where((p) => !cartIds.contains(p.id)).toList();
  if (pool.isEmpty) return const [];

  // 3) Weighted random pick (เลือก 4 ชิ้นแบบไม่ซ้ำ)
  final rnd = Random();
  final List<Product> picked = [];
  final Set<String> pickedIds = {};

  int weightOf(Product p) {
    final w = weightByCat[p.categoryId] ?? 0;
    return max(1, w); // อย่างน้อย 1 เพื่อยังสุ่มได้
  }

  Product weightedPick(List<Product> candidates) {
    final total = candidates.fold<int>(0, (s, p) => s + weightOf(p));
    var r = rnd.nextInt(total);
    for (final p in candidates) {
      r -= weightOf(p);
      if (r < 0) return p;
    }
    return candidates.last;
  }

  var tries = 0;
  while (picked.length < 8 && tries < 50) {
    tries++;

    // เพิ่ม “แรง” ให้หมวดเดียวกับตะกร้า: กรอง candidates ให้เน้นหมวดเด่นก่อน
    final topCat = weightByCat.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final preferCat = topCat.isNotEmpty ? topCat.first.key : null;

    final candidates = preferCat == null
        ? pool
        : (pool.where((p) => p.categoryId == preferCat).toList().isNotEmpty
              ? pool.where((p) => p.categoryId == preferCat).toList()
              : pool);

    final p = weightedPick(candidates);
    if (pickedIds.add(p.id)) picked.add(p);
  }

  return picked;
});
