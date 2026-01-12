import 'package:flutter/material.dart';
import 'package:onelamarket_app/features/profile/presentation/controllers/address_controller.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/show_onela_sheet.dart';

import 'address_list_sheet.dart';

class AddressMenuSheet extends StatelessWidget {
  const AddressMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header เหมือน AccountInfoSheet
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 4),
              const Text('ที่อยู่', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),

          _InfoRow(
            title: 'ที่อยู่จัดส่ง',
            subtitle: 'ที่อยู่สำหรับส่งสินค้า',
            onTap: () => showOnelaSheet(
              context: context,
              child: const AddressListSheet(type: AddressType.delivery),
              initial: 0.92,
            ),
          ),

          _InfoRow(
            title: 'ที่อยู่สำหรับส่งใบเสร็จ',
            subtitle: 'ที่อยู่สำหรับออกเอกสาร/ใบเสร็จ',
            onTap: () => showOnelaSheet(
              context: context,
              child: const AddressListSheet(type: AddressType.billing),
              initial: 0.92,
            ),
          ),
        ],
      ),
    );
  }
}

// ใช้หน้าตาเดียวกับ AccountInfoSheet
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
