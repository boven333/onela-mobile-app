import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/core/routing/routes.dart';
import 'package:onelamarket_app/features/profile/presentation/controllers/address_controller.dart';
import 'package:onelamarket_app/features/profile/presentation/pages/address_form_page.dart';

class AddressListSheet extends ConsumerWidget {
  const AddressListSheet({super.key, required this.type});
  final AddressType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addressProvider);
    final list = state.listOf(type);

    final title = type == AddressType.delivery ? 'ที่อยู่จัดส่ง' : 'ที่อยู่จัดส่งใบเสร็จ';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header เหมือน AccountInfoSheet แต่มีปุ่มเพิ่มที่อยู่
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.addressForm,
                    arguments: AddressFormArgs(type: type, editing: null),
                  );
                },
                child: const Text('เพิ่มที่อยู่', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),

          // ✅ ให้ list เป็นตัวคุมความสูง (ป้องกัน unbounded)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 10),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final a = list[i];
                return _InfoRow(
                  title: a.displayLine,
                  subtitle: a.note?.isNotEmpty == true ? a.note! : 'แตะเพื่อแก้ไข',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.addressForm,
                      arguments: AddressFormArgs(type: type, editing: a),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// หน้าตาเหมือน AccountInfoSheet เป๊ะ
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
