import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/routing/routes.dart';
import 'auth_controller.dart'; // ใช้ userModeProvider
import 'signup_flow_state.dart';

final signupFlowProvider = StateNotifierProvider<SignupFlowController, SignupFlowState>(
  (ref) => SignupFlowController(ref),
);

class SignupFlowController extends StateNotifier<SignupFlowState> {
  SignupFlowController(this.ref) : super(SignupFlowState.empty);

  final Ref ref;

  void reset() => state = SignupFlowState.empty;

  void setAuthMethod(AuthMethod method, {String? email}) {
    state = state.copyWith(method: method, email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setBusinessType(BusinessType type) {
    state = state.copyWith(businessType: type);
  }

  void setBusinessInfo({
    required String restaurantName,
    required String contactName,
    required String phone,
    // company
    String? companyName,
    String? juristicId,
    String? companyAddress,
    // individual
    String? firstName,
    String? lastName,
    String? nationalId,
    String? idCardAddress,
  }) {
    state = state.copyWith(
      restaurantName: restaurantName,
      contactName: contactName,
      phone: phone,
      companyName: companyName,
      juristicId: juristicId,
      companyAddress: companyAddress,
      firstName: firstName,
      lastName: lastName,
      nationalId: nationalId,
      idCardAddress: idCardAddress,
    );
  }

  void setAddress({
    required String province,
    required String district,
    required String subdistrict,
    required String postalCode,
  }) {
    state = state.copyWith(
      province: province,
      district: district,
      subdistrict: subdistrict,
      postalCode: postalCode,
    );
  }

  // ===== Navigation Rules (ตามที่มึงสรุปไว้) =====

  String nextAfterRegister() {
    final mode = ref.read(userModeProvider);

    // social -> household ไป shop, business ไป business-info
    if (state.method == AuthMethod.social) {
      return mode == UserMode.household ? Routes.shop : Routes.businessInfo;
    }

    // email -> ไป password ทั้งคู่
    return Routes.password;
  }

  String nextAfterPassword() {
    final mode = ref.read(userModeProvider);
    return mode == UserMode.household ? Routes.shop : Routes.businessInfo;
  }

  String nextAfterBusinessInfo() => Routes.address;

  String nextAfterAddress() => Routes.shop;
}
