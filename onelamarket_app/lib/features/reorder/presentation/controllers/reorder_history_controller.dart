import 'package:flutter_riverpod/legacy.dart';

class ReorderHistoryState {
  final List<String> productIds; // เก็บ id สินค้าที่เคยสั่งล่าสุด (เรียงล่าสุดก่อน)
  final Set<String> hiddenIds; // ซ่อนไว้ (ผู้ใช้ลบออกจาก reorder)

  const ReorderHistoryState({required this.productIds, required this.hiddenIds});

  ReorderHistoryState copyWith({List<String>? productIds, Set<String>? hiddenIds}) {
    return ReorderHistoryState(
      productIds: productIds ?? this.productIds,
      hiddenIds: hiddenIds ?? this.hiddenIds,
    );
  }
}

class ReorderHistoryController extends StateNotifier<ReorderHistoryState> {
  ReorderHistoryController() : super(const ReorderHistoryState(productIds: [], hiddenIds: {}));

  /// เรียกตอน "สั่งซื้อสำเร็จ" โดยส่งรายการ productIds ที่ถูกสั่งในออเดอร์นั้น
  void addOrder(List<String> orderedProductIds) {
    if (orderedProductIds.isEmpty) return;

    // รวมแบบ "ล่าสุดก่อน" และตัดซ้ำ
    final next = <String>[
      ...orderedProductIds.reversed, // ให้ของในออเดอร์ล่าสุดขึ้นก่อน
      ...state.productIds,
    ];

    final seen = <String>{};
    final unique = <String>[];
    for (final id in next) {
      if (seen.add(id)) unique.add(id);
    }

    state = state.copyWith(productIds: unique);
  }

  void remove(String productId) {
    state = state.copyWith(hiddenIds: {...state.hiddenIds, productId});
  }

  void undoRemove(String productId) {
    final next = {...state.hiddenIds}..remove(productId);
    state = state.copyWith(hiddenIds: next);
  }

  void clearAll() {
    state = const ReorderHistoryState(productIds: [], hiddenIds: {});
  }
}

final reorderHistoryProvider = StateNotifierProvider<ReorderHistoryController, ReorderHistoryState>(
  (ref) {
    return ReorderHistoryController();
  },
);
