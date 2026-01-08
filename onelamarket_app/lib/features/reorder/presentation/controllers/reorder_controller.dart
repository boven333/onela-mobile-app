import 'package:flutter_riverpod/legacy.dart';

import '../../../shop/data/mock/mock_catalog.dart';
import '../../../shop/domain/models/product.dart';

class ReorderState {
  final List<Product> items;
  final Set<String> hiddenIds;

  const ReorderState({required this.items, required this.hiddenIds});

  ReorderState copyWith({List<Product>? items, Set<String>? hiddenIds}) {
    return ReorderState(items: items ?? this.items, hiddenIds: hiddenIds ?? this.hiddenIds);
  }
}

class ReorderController extends StateNotifier<ReorderState> {
  ReorderController()
    : super(
        ReorderState(
          // mock: เอาเยอะ ๆ ให้เลื่อนได้
          items: MockCatalog.products.take(120).toList(),
          hiddenIds: <String>{},
        ),
      );

  void remove(String productId) {
    final next = {...state.hiddenIds, productId};
    state = state.copyWith(hiddenIds: next);
  }

  void undoRemove(String productId) {
    final next = {...state.hiddenIds}..remove(productId);
    state = state.copyWith(hiddenIds: next);
  }

  void reset() {
    state = state.copyWith(hiddenIds: <String>{});
  }
}

final reorderControllerProvider = StateNotifierProvider<ReorderController, ReorderState>((ref) {
  return ReorderController();
});
