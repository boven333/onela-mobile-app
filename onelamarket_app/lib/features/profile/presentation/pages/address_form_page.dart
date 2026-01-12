import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/address_controller.dart';

class AddressFormArgs {
  final AddressType type;
  final AddressModel? editing;
  const AddressFormArgs({required this.type, required this.editing});
}

class AddressFormPage extends ConsumerStatefulWidget {
  const AddressFormPage({super.key});

  @override
  ConsumerState<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends ConsumerState<AddressFormPage> {
  final _line1 = TextEditingController();
  final _subdistrict = TextEditingController();
  final _district = TextEditingController();
  final _province = TextEditingController();
  final _postcode = TextEditingController();

  AddressFormArgs _args(BuildContext context) {
    final a = ModalRoute.of(context)?.settings.arguments;
    if (a is AddressFormArgs) return a;
    return const AddressFormArgs(type: AddressType.delivery, editing: null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = _args(context);
    final e = args.editing;
    if (e != null && _line1.text.isEmpty) {
      _line1.text = e.line1;
      _subdistrict.text = e.subdistrict;
      _district.text = e.district;
      _province.text = e.province;
      _postcode.text = e.postcode;
    }
  }

  @override
  void dispose() {
    _line1.dispose();
    _subdistrict.dispose();
    _district.dispose();
    _province.dispose();
    _postcode.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF111827)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = _args(context);
    final isEdit = args.editing != null;

    final title = isEdit
        ? (args.type == AddressType.delivery ? 'แก้ไขที่อยู่จัดส่ง' : 'แก้ไขที่อยู่จัดส่งใบเสร็จ')
        : (args.type == AddressType.delivery ? 'เพิ่มที่อยู่จัดส่ง' : 'เพิ่มที่อยู่จัดส่งใบเสร็จ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          // Map placeholder (ตามรูป)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 130,
              color: const Color(0xFFE5E7EB),
              alignment: Alignment.center,
              child: const Text('MAP (placeholder)', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(height: 16),

          TextField(controller: _line1, decoration: _dec('ที่อยู่')),
          const SizedBox(height: 12),
          TextField(controller: _subdistrict, decoration: _dec('ตำบล')),
          const SizedBox(height: 12),
          TextField(controller: _district, decoration: _dec('อำเภอ')),
          const SizedBox(height: 12),
          TextField(controller: _province, decoration: _dec('จังหวัด')),
          const SizedBox(height: 12),
          TextField(
            controller: _postcode,
            keyboardType: TextInputType.number,
            decoration: _dec('รหัสไปรษณีย์'),
          ),

          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6C15A), // โทนปุ่มทอง onela
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              onPressed: () {
                final ctrl = ref.read(addressProvider.notifier);
                final id = args.editing?.id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}';

                final model = AddressModel(
                  id: id,
                  line1: _line1.text.trim(),
                  subdistrict: _subdistrict.text.trim(),
                  district: _district.text.trim(),
                  province: _province.text.trim(),
                  postcode: _postcode.text.trim(),
                  note: isEdit ? args.editing?.note : null, // จะทำฟิลด์ note เพิ่มทีหลังก็ได้
                );

                ctrl.upsert(args.type, model);
                Navigator.pop(context);
              },
              child: const Text(
                'บันทึก',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
