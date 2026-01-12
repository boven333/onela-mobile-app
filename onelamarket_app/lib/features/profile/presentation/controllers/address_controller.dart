import 'package:flutter_riverpod/legacy.dart';

enum AddressType { delivery, billing }

class AddressModel {
  final String id;
  final String line1; // 999/1 หมู่ 1
  final String subdistrict; // ตำบล
  final String district; // อำเภอ
  final String province; // จังหวัด
  final String postcode; // รหัสไปรษณีย์
  final String? note; // บ้านหลังที่ 20 จากหน้าโครงการ

  const AddressModel({
    required this.id,
    required this.line1,
    required this.subdistrict,
    required this.district,
    required this.province,
    required this.postcode,
    this.note,
  });

  String get displayLine => '$line1 $district, $province';
}

class AddressState {
  final List<AddressModel> delivery;
  final List<AddressModel> billing;

  const AddressState({this.delivery = const [], this.billing = const []});

  AddressState copyWith({List<AddressModel>? delivery, List<AddressModel>? billing}) {
    return AddressState(delivery: delivery ?? this.delivery, billing: billing ?? this.billing);
  }

  List<AddressModel> listOf(AddressType type) => type == AddressType.delivery ? delivery : billing;
}

final addressProvider = StateNotifierProvider<AddressController, AddressState>((ref) {
  return AddressController()..seedMock(); // ✅ MVP: มี 1 ที่อยู่ให้เหมือนรูป
});

class AddressController extends StateNotifier<AddressState> {
  AddressController() : super(const AddressState());

  void seedMock() {
    if (state.delivery.isNotEmpty) return;
    final mock = AddressModel(
      id: 'addr_001',
      line1: '999/1 หมู่ 1',
      subdistrict: 'เชียงใหม่',
      district: 'เชียงใหม่',
      province: 'เชียงใหม่',
      postcode: '50000',
      note: 'บ้านหลังที่ 20 จากหน้าโครงการ',
    );
    state = state.copyWith(delivery: [mock], billing: [mock]);
  }

  void upsert(AddressType type, AddressModel model) {
    final list = [...state.listOf(type)];
    final idx = list.indexWhere((x) => x.id == model.id);
    if (idx >= 0) {
      list[idx] = model;
    } else {
      list.insert(0, model);
    }
    if (type == AddressType.delivery) {
      state = state.copyWith(delivery: list);
    } else {
      state = state.copyWith(billing: list);
    }
  }
}
