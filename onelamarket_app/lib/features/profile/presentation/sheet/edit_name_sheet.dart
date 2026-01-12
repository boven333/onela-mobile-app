import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../controllers/profile_account_controller.dart';

class EditNameSheet extends ConsumerStatefulWidget {
  const EditNameSheet({super.key});

  @override
  ConsumerState<EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends ConsumerState<EditNameSheet> {
  late final TextEditingController firstCtrl;
  late final TextEditingController lastCtrl;

  @override
  void initState() {
    super.initState();
    final full = ref.read(profileAccountProvider).fullName.trim();
    final parts = full.split(' ');
    firstCtrl = TextEditingController(text: parts.isNotEmpty ? parts.first : '');
    lastCtrl = TextEditingController(text: parts.length > 1 ? parts.sublist(1).join(' ') : '');
  }

  @override
  void dispose() {
    firstCtrl.dispose();
    lastCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = firstCtrl.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
          const SizedBox(height: 4),
          const Text('แก้ไขชื่อ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 16),

          _Field(controller: firstCtrl, hint: 'ชื่อจริง', onChanged: (_) => setState(() {})),
          const SizedBox(height: 12),
          _Field(controller: lastCtrl, hint: 'นามสกุล', onChanged: (_) => setState(() {})),

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
                      final full = '${firstCtrl.text.trim()} ${lastCtrl.text.trim()}'.trim();
                      ref.read(profileAccountProvider.notifier).setName(full);
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
