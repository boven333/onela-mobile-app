import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/edit_email_sheet.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/edit_name_sheet.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/edit_phone_sheet.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/show_onela_sheet.dart';

import '../controllers/profile_account_controller.dart';

class AccountInfoSheet extends ConsumerWidget {
  const AccountInfoSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acc = ref.watch(profileAccountProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 4),
              const Text(
                'ข้อมูลบัญชี',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),

          _InfoRow(
            title: acc.email,
            subtitle: 'อีเมล',
            onTap: () => showOnelaSheet(context: context, child: const EditEmailSheet()),
          ),
          _InfoRow(
            title: acc.fullName,
            subtitle: 'ชื่อ',
            onTap: () => showOnelaSheet(context: context, child: const EditNameSheet()),
          ),
          _InfoRow(
            title: acc.phone,
            subtitle: 'โทรศัพท์',
            onTap: () => showOnelaSheet(context: context, child: const EditPhoneSheet()),
          ),

          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('ลบบัญชี (mock)')));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('ลบบัญชี', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
