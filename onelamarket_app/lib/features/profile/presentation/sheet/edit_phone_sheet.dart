import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../controllers/profile_account_controller.dart';

class EditPhoneSheet extends ConsumerStatefulWidget {
  const EditPhoneSheet({super.key});

  @override
  ConsumerState<EditPhoneSheet> createState() => _EditPhoneSheetState();
}

class _EditPhoneSheetState extends ConsumerState<EditPhoneSheet> {
  late final TextEditingController phoneCtrl;

  @override
  void initState() {
    super.initState();
    phoneCtrl = TextEditingController(text: ref.read(profileAccountProvider).phone);
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = phoneCtrl.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
          const SizedBox(height: 4),
          const Text(
            'ยืนยันเบอร์โทรศัพท์',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),

          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              onPressed: !canSave
                  ? null
                  : () {
                      ref.read(profileAccountProvider.notifier).setPhone(phoneCtrl.text.trim());
                      Navigator.pop(context);
                    },
              child: const Text('บันทึก', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
