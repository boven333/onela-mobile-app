import 'package:flutter/material.dart';
import 'package:onelamarket_app/features/orders/presentation/pages/order_page.dart';
import 'package:onelamarket_app/features/reorder/presentation/pages/reorder_page.dart';

import '../../../shop/presentation/pages/shop_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [ShopPage(), ReorderPage(), OrdersPage(), _MorePageMock()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          color: Colors.white,
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'สินค้า',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.loop_outlined), // ตามภาพใกล้เคียง
                activeIcon: Icon(Icons.loop),
                label: 'สั่งซื้อซ้ำ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'ออเดอร์',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                activeIcon: Icon(Icons.more_horiz),
                label: 'อื่นๆ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Mock pages ไว้ก่อน =====
class _OrdersPageMock extends StatelessWidget {
  const _OrdersPageMock();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Center(child: Text('สั่งซื้อ (mock)'))),
    );
  }
}

class _OrderTrackingPageMock extends StatelessWidget {
  const _OrderTrackingPageMock();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Center(child: Text('ออเดอร์ (mock)'))),
    );
  }
}

class _MorePageMock extends StatelessWidget {
  const _MorePageMock();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Center(child: Text('อื่นๆ (mock)'))),
    );
  }
}
