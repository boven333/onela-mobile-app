import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/core/constants/app_colors.dart';

import '../../../../core/constants/app_sizes.dart';
import '../controllers/signup_flow_controller.dart';

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({super.key});

  @override
  ConsumerState<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
  final _province = TextEditingController();
  final _district = TextEditingController();
  final _subdistrict = TextEditingController();
  final _postal = TextEditingController();

  @override
  void dispose() {
    _province.dispose();
    _district.dispose();
    _subdistrict.dispose();
    _postal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.read(signupFlowProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ที่อยู่จัดส่ง'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _province,
                      decoration: const InputDecoration(hintText: 'จังหวัด'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _district,
                      decoration: const InputDecoration(hintText: 'อำเภอ'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _subdistrict,
                      decoration: const InputDecoration(hintText: 'ตำบล'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _postal,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'รหัสไปรษณีย์'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppSizes.buttonH,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  onPressed: () {
                    flow.setAddress(
                      province: _province.text.trim(),
                      district: _district.text.trim(),
                      subdistrict: _subdistrict.text.trim(),
                      postalCode: _postal.text.trim(),
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      flow.nextAfterAddress(),
                      (r) => false,
                    );
                  },
                  child: const Text(
                    'ดำเนินการต่อ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
