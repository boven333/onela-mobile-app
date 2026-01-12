import 'package:flutter/material.dart';
import 'package:onelamarket_app/core/constants/app_colors.dart';
import 'package:onelamarket_app/features/profile/presentation/sheet/settings_sheet.dart';

import '../../../../core/constants/app_sizes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ แบบรูปที่ 1
      appBar: AppBar(
        backgroundColor: AppColors.brand,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ปุณณรพร งามดี',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        centerTitle: true,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: _TopActionButton(
                    icon: Icons.settings,
                    label: 'ตั้งค่า',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const SettingsSheet(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TopActionButton(
                    icon: Icons.help_outline,
                    label: 'ช่วยเหลือ',
                    onPressed: () {
                      // Navigator.pushNamed(context, Routes.help);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSizes.p16, 8, AppSizes.p16, 20),
          children: [
            //   // ===== top buttons =====
            //   Row(
            //     children: const [
            //       Expanded(
            //         child: _TopActionButton(icon: Icons.receipt_long, label: 'คำสั่งซื้อ'),
            //       ),
            //       SizedBox(width: 10),
            //       Expanded(
            //         child: _TopActionButton(icon: Icons.settings, label: 'ตั้งค่า'),
            //       ),
            //       SizedBox(width: 10),
            //       Expanded(
            //         child: _TopActionButton(icon: Icons.help_outline, label: 'ช่วยเหลือ'),
            //       ),
            //     ],
            //   ),
            const SizedBox(height: 18),

            const Text('ตัวเลือก', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 8),

            // ✅ แบบรูปที่ 1: แบนๆ ไม่ใช่ card
            _SimpleMenuTile(
              title: 'หน้าแรกของบัญชี',
              subtitle: 'คำสั่งซื้อทั้งหมด / สินค้าที่สั่งซื้อ',
              onTap: () {},
            ),
            _SimpleMenuTile(title: 'ชื่อ', subtitle: 'โน่นไง๊ / นะเธอ', onTap: () {}),
            _SimpleMenuTile(
              title: 'ข้อมูลสถิติ',
              subtitle: 'ยอดคำสั่งซื้อทั้งหมด / จำนวนที่สั่งซื้อทั้งหมด และ อื่นๆ',
              onTap: () {},
            ),

            const SizedBox(height: 14),

            // ✅ ออกจากระบบแบบในรูปที่ 1
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('ออกจากระบบ', style: TextStyle(fontWeight: FontWeight.w800)),
              onTap: () {
                // TODO: mock logout
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({required this.icon, required this.label, required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed, // ✅ ตรงนี้แหละ
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleMenuTile extends StatelessWidget {
  const _SimpleMenuTile({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: const TextStyle()),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          trailing: const Icon(Icons.chevron_right, color: Colors.black54),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
