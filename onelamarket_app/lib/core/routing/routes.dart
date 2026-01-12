class Routes {
  static const main = '/main';

  static const welcome = '/welcome';
  static const register = '/register';
  static const login = '/login';

  static const password = '/password';
  static const businessInfo = '/business-info';
  static const address = '/address';

  // NEW (commerce)
  static const shop = '/shop';
  static const cart = '/cart';
  static const checkout = '/checkout';

  static const orders = '/orders';
  static const orderDetail = '/order-detail';

  static const profile = '/profile';
  static const settings = '/settings';
  static const addressMenu = '/settings/address';
  static const addressList = '/settings/address/list'; // arguments: AddressType
  static const addressForm = '/settings/address/form'; // arguments: AddressFormArgs
}
