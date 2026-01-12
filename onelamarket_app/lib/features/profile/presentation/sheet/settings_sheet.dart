import 'package:flutter/material.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/account_info_sheet.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/address_menu_sheet.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/show_onela_sheet.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9, // 👈 เปิดมาสูง 70%
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController, // สำคัญ
            children: [
              // ===== Header =====
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'ตั้งค่า',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              _Item(
                icon: Icons.person,
                title: 'ข้อมูลทั่วไป',
                onTap: () => showOnelaSheet(
                  context: context,
                  child: const AccountInfoSheet(),
                  initial: 0.92,
                ),
              ),
              _Item(
                icon: Icons.location_on,
                title: 'ที่อยู่',
                onTap: () => showOnelaSheet(
                  context: context,
                  child: const AddressMenuSheet(),
                  initial: 0.92, // สูงพอๆ กับข้อมูลทั่วไป
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
