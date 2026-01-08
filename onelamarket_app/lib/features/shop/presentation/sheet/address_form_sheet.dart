import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key, required this.onSave});

  final void Function(String addressLine) onSave;

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  final _group = TextEditingController();
  final _subdistrict = TextEditingController();
  final _district = TextEditingController();
  final _province = TextEditingController();
  final _postal = TextEditingController();

  @override
  void dispose() {
    _group.dispose();
    _subdistrict.dispose();
    _district.dispose();
    _province.dispose();
    _postal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                const Expanded(
                  child: Text(
                    'ที่อยู่สำหรับจัดส่ง',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 10),

            // map placeholder
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text('MAP (mock)', style: TextStyle(fontWeight: FontWeight.w800)),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _group,
              decoration: const InputDecoration(hintText: 'กลุ่ม'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _subdistrict,
              decoration: const InputDecoration(hintText: 'ตำบล'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _district,
              decoration: const InputDecoration(hintText: 'อำเภอ'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _province,
              decoration: const InputDecoration(hintText: 'จังหวัด'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _postal,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'รหัสไปรษณีย์'),
            ),

            const SizedBox(height: 12),
            SizedBox(
              height: AppSizes.buttonH,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: () {
                  final line =
                      '${_group.text.trim()} ${_subdistrict.text.trim()} ${_district.text.trim()} ${_province.text.trim()} ${_postal.text.trim()}'
                          .trim();
                  widget.onSave(line.isEmpty ? 'ที่อยู่ (mock)' : line);
                  Navigator.pop(context);
                },
                child: const Text('บันทึก', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
