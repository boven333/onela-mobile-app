import 'package:flutter/material.dart';

import '../../../../core/routing/routes.dart';
import '../controllers/address_controller.dart';

class AddressMenuPage extends StatelessWidget {
  const AddressMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ที่อยู่',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('ที่อยู่จัดส่ง', style: TextStyle(fontWeight: FontWeight.w800)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                Navigator.pushNamed(context, Routes.addressList, arguments: AddressType.delivery),
          ),
          ListTile(
            title: const Text(
              'ที่อยู่สำหรับส่งใบเสร็จ',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                Navigator.pushNamed(context, Routes.addressList, arguments: AddressType.billing),
          ),
        ],
      ),
    );
  }
}
