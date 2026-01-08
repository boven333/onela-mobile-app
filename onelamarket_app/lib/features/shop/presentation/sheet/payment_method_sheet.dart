import 'package:flutter/material.dart';

import '../../presentation/controllers/checkout_controller.dart';

class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({super.key, required this.onSelect});

  final void Function(PaymentMethod method) onSelect;

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
                    'ช่องทางการชำระเงิน',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 12),
            _option(
              context,
              icon: Icons.credit_card,
              title: 'ชำระเงินออนไลน์',
              subtitle: 'บัตรเครดิต, พร้อมเพย์, โอนธนาคาร',
              onTap: () {
                onSelect(PaymentMethod.online);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _option(
              context,
              icon: Icons.payments_outlined,
              title: 'เก็บเงินปลายทาง (COD)',
              subtitle: 'ชำระเงินเมื่อได้รับสินค้า',
              onTap: () {
                onSelect(PaymentMethod.cod);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
