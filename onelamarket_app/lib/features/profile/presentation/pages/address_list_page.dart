import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routing/routes.dart';
import '../controllers/address_controller.dart';
import 'address_form_page.dart';

class AddressListPage extends ConsumerWidget {
  const AddressListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final type = arg is AddressType ? arg : AddressType.delivery;

    final state = ref.watch(addressProvider);
    final list = state.listOf(type);

    final title = type == AddressType.delivery ? 'ที่อยู่จัดส่ง' : 'ที่อยู่จัดส่งใบเสร็จ';

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
        actions: [
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
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final a = list[i];
          return _AddressTile(
            title: a.displayLine,
            subtitle: a.note ?? '',
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
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w700),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
