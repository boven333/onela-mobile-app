import 'package:flutter/material.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/account_info_sheet.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/address_menu_sheet.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/show_onela_sheet.dart';

import '../../../../core/constants/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand, // ถ้ามี theme onela / ถ้าไม่มีใช้ Colors.white
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [BoxShadow(blurRadius: 20, color: Color(0x22000000), offset: Offset(0, -2))],
          ),
          child: Column(
            children: [
              // Header (X + Title)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
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

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
