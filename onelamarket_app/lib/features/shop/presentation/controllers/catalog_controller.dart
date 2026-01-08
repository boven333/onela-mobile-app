import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/mock/mock_catalog.dart';
import '../../domain/models/product.dart';

final selectedCategoryIdProvider = StateProvider<String>((ref) => 'cat_all');
final searchQueryProvider = StateProvider<String>((ref) => '');

final categoriesProvider = Provider<List<Category>>((ref) => MockCatalog.categories);

final productsProvider = Provider<List<Product>>((ref) {
  final catId = ref.watch(selectedCategoryIdProvider);
  final q = ref.watch(searchQueryProvider).trim().toLowerCase();

  var list = MockCatalog.products;
  if (catId != 'cat_all') {
    list = list.where((p) => p.categoryId == catId).toList();
  }
  if (q.isNotEmpty) {
    list = list.where((p) => p.name.toLowerCase().contains(q)).toList();
  }
  return list;
});

// map: categoryId -> products
final productsGroupedProvider = Provider<Map<String, List<Product>>>((ref) {
  final q = ref.watch(searchQueryProvider).trim().toLowerCase();

  // ถ้า search มีค่า ให้ filter ก่อน แล้วค่อย group
  final list = q.isEmpty
      ? MockCatalog.products
      : MockCatalog.products.where((p) => p.name.toLowerCase().contains(q)).toList();

  final map = <String, List<Product>>{};
  for (final p in list) {
    map.putIfAbsent(p.categoryId, () => <Product>[]).add(p);
  }
  return map;
});
