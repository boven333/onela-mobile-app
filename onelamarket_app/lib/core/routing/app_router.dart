import 'package:flutter/material.dart';
import 'package:onelamarket_app/features/auth/presentation/pages/profile_page.dart';
import 'package:onelamarket_app/features/orders/presentation/pages/order_detail_page.dart';
import 'package:onelamarket_app/features/orders/presentation/pages/order_page.dart';
import 'package:onelamarket_app/features/profile/presentation/pages/address_form_page.dart';
import 'package:onelamarket_app/features/profile/presentation/pages/address_list_page.dart';
import 'package:onelamarket_app/features/profile/presentation/pages/address_menu_page.dart';
import 'package:onelamarket_app/features/profile/presentation/pages/settings_page.dart'
    show SettingsPage;
import 'package:onelamarket_app/features/shell/presentation/pages/main_shell.dart';
import 'package:onelamarket_app/features/shop/presentation/pages/shop_page.dart';

import '../../features/auth/presentation/pages/address_page.dart';
import '../../features/auth/presentation/pages/business_info_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/password_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/shop/presentation/pages/cart_page.dart';
import '../../features/shop/presentation/pages/checkout_page.dart';
import 'routes.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.password:
        return MaterialPageRoute(builder: (_) => const PasswordPage());
      case Routes.businessInfo:
        return MaterialPageRoute(builder: (_) => const BusinessInfoPage());
      case Routes.address:
        return MaterialPageRoute(builder: (_) => const AddressPage());

      case Routes.shop:
        return MaterialPageRoute(builder: (_) => const ShopPage());
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case Routes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutPage());

      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case Routes.main:
        return MaterialPageRoute(builder: (_) => const MainShell());

      case Routes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersPage());

      case Routes.orderDetail:
        final args = settings.arguments; // ✅ สำคัญมาก
        return MaterialPageRoute(
          settings: settings, // ✅ สำคัญ (ช่วยให้ ModalRoute มองเห็น arguments)
          builder: (_) => const OrderDetailPage(),
        );

      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage(), settings: settings);
      case Routes.addressMenu:
        return MaterialPageRoute(builder: (_) => const AddressMenuPage(), settings: settings);
      case Routes.addressList:
        return MaterialPageRoute(builder: (_) => const AddressListPage(), settings: settings);
      case Routes.addressForm:
        return MaterialPageRoute(builder: (_) => const AddressFormPage(), settings: settings);

      default:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
    }
  }
}
