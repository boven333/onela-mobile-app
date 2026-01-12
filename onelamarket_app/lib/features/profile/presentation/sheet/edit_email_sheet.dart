import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../controllers/profile_account_controller.dart';

class EditEmailSheet extends ConsumerStatefulWidget {
  const EditEmailSheet({super.key});

  @override
  ConsumerState<EditEmailSheet> createState() => _EditEmailSheetState();
}

class _EditEmailSheetState extends ConsumerState<EditEmailSheet> {
  late final TextEditingController emailCtrl;
  late final TextEditingController confirmCtrl;

  @override
  void initState() {
    super.initState();
    final acc = ref.read(profileAccountProvider);
    emailCtrl = TextEditingController(text: acc.email);
    confirmCtrl = TextEditingController(text: acc.email);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = emailCtrl.text.isNotEmpty && emailCtrl.text == confirmCtrl.text;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
          const SizedBox(height: 4),
          const Text('แก้ไขอีเมล', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 16),

          _Field(controller: emailCtrl, hint: 'อีเมลใหม่', onChanged: (_) => setState(() {})),
          const SizedBox(height: 12),
          _Field(
            controller: confirmCtrl,
            hint: 'ยืนยัน อีเมลใหม่',
            onChanged: (_) => setState(() {}),
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
                      ref.read(profileAccountProvider.notifier).setEmail(emailCtrl.text.trim());
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

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.hint, this.onChanged});

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }
}
