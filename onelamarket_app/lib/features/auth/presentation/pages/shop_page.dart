// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:onelamarket_app/features/shop/presentation/controllers/cart_controller.dart';
// import 'package:onelamarket_app/features/shop/presentation/controllers/catalog_controller.dart';
// import 'package:onelamarket_app/features/shop/presentation/widgets/product_card.dart';

// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_sizes.dart';
// import '../../../../core/routing/routes.dart';

// class ShopPage extends ConsumerWidget {
//   const ShopPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final categories = ref.watch(categoriesProvider);
//     final selectedCat = ref.watch(selectedCategoryIdProvider);

//     final grouped = ref.watch(productsGroupedProvider);

//     final cartItems = ref.watch(cartProvider);
//     final cartCount = cartItems.fold<int>(0, (s, x) => s + x.qty);

//     // helper: เอาชื่อหมวดจาก id
//     String catName(String id) {
//       final c = categories.firstWhere((x) => x.id == id, orElse: () => categories.first);
//       return c.name;
//     }

//     // list ของ category ที่จะแสดงเป็น section
//     final sectionCategoryIds = selectedCat == 'cat_all'
//         ? categories.where((c) => c.id != 'cat_all').map((c) => c.id).toList()
//         : [selectedCat];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 // ===== HEADER =====
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(AppSizes.p16, AppSizes.p16, AppSizes.p16, 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Expanded(
//                             child: Text(
//                               'เชียงใหม่',
//                               style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () => Navigator.pushNamed(context, Routes.profile),
//                             icon: const Icon(Icons.person_outline),
//                           ),
//                           IconButton(
//                             onPressed: cartCount == 0
//                                 ? null
//                                 : () => Navigator.pushNamed(context, Routes.cart),
//                             icon: const Icon(Icons.shopping_cart_outlined),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       TextField(
//                         onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
//                         decoration: InputDecoration(
//                           hintText: 'ค้นหา รายการสินค้า',
//                           prefixIcon: const Icon(Icons.search),
//                           filled: true,
//                           fillColor: const Color(0xFFF3F4F6),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(999),
//                             borderSide: const BorderSide(color: Colors.transparent),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(999),
//                             borderSide: const BorderSide(color: Colors.transparent),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),

//                       // Categories row (วงกลม)
//                       SizedBox(
//                         height: 86,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: categories.length,
//                           separatorBuilder: (_, __) => const SizedBox(width: 14),
//                           itemBuilder: (context, i) {
//                             final c = categories[i];
//                             final isSel = c.id == selectedCat;

//                             return _CategoryItem(
//                               label: c.name,
//                               iconPath: c.iconPath,
//                               selected: isSel,
//                               onTap: () =>
//                                   ref.read(selectedCategoryIdProvider.notifier).state = c.id,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ===== SECTIONS =====
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.only(bottom: 120),
//                     itemCount: sectionCategoryIds.length,
//                     itemBuilder: (context, index) {
//                       final catId = sectionCategoryIds[index];
//                       final items = grouped[catId] ?? const [];

//                       // ถ้าไม่มีสินค้าในหมวด (เช่น search แล้วไม่ตรง) ก็ซ่อน section ไปเลย
//                       if (items.isEmpty) return const SizedBox.shrink();

//                       return _Section(
//                         title: catName(catId),
//                         products: items,
//                         onAdd: (p) => ref.read(cartProvider.notifier).add(p),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),

//             // ===== Floating cart button (โผล่เมื่อมีของ) =====
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 14,
//               child: SafeArea(
//                 top: false,
//                 child: AnimatedSlide(
//                   duration: const Duration(milliseconds: 180),
//                   curve: Curves.easeOut,
//                   offset: cartCount > 0 ? Offset.zero : const Offset(0, 1.2),
//                   child: AnimatedOpacity(
//                     duration: const Duration(milliseconds: 180),
//                     opacity: cartCount > 0 ? 1 : 0,
//                     child: Center(
//                       child: SizedBox(
//                         width: 240,
//                         height: 52,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.brand,
//                             foregroundColor: Colors.black,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
//                           ),
//                           onPressed: () => Navigator.pushNamed(context, Routes.cart),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.shopping_cart_outlined),
//                               const SizedBox(width: 8),
//                               Text(
//                                 '$cartCount',
//                                 style: const TextStyle(fontWeight: FontWeight.w900),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Section extends StatelessWidget {
//   const _Section({required this.title, required this.products, required this.onAdd});

//   final String title;
//   final List products; // Product
//   final void Function(dynamic p) onAdd;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
//             child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
//           ),
//           const SizedBox(height: 10),
//           SizedBox(
//             height: 220,
//             child: ListView.separated(
//               padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
//               scrollDirection: Axis.horizontal,
//               itemCount: products.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 12),
//               itemBuilder: (context, i) {
//                 final p = products[i];
//                 return SizedBox(
//                   width: 160,
//                   child: ProductCard(
//                     imageAsset: p.imageAsset,
//                     title: p.name,
//                     subtitle: p.subtitle,
//                     priceText: '฿${p.price}',
//                     onAdd: () => onAdd(p),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CategoryItem extends StatelessWidget {
//   const _CategoryItem({
//     required this.label,
//     required this.iconPath,
//     required this.selected,
//     required this.onTap,
//   });

//   final String label;
//   final String? iconPath;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: onTap,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(
//               color: selected ? const Color(0xFF111827) : const Color(0xFF374151),
//               shape: BoxShape.circle,
//             ),
//             alignment: Alignment.center,
//             child: iconPath == null
//                 ? const Icon(Icons.circle, color: Colors.white, size: 18) // placeholder
//                 : SizedBox(
//                     width: 46,
//                     height: 46,
//                     child: Image.asset(
//                       iconPath!,
//                       fit: BoxFit.cover, // แน่นขึ้น (แต่บางรูปอาจโดน crop)
//                     ),
//                   ),
//           ),
//           const SizedBox(height: 6),
//           SizedBox(
//             width: 56,
//             child: Text(
//               label,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
