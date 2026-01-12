import 'package:flutter_riverpod/legacy.dart';

class ProfileAccountState {
  final String email;
  final String fullName;
  final String phone;

  const ProfileAccountState({
    this.email = 'mail@gmail.com',
    this.fullName = 'ปุณณเมธ งามดี',
    this.phone = '+66 979466191',
  });

  ProfileAccountState copyWith({String? email, String? fullName, String? phone}) {
    return ProfileAccountState(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
    );
  }
}

final profileAccountProvider = StateNotifierProvider<ProfileAccountController, ProfileAccountState>(
  (ref) => ProfileAccountController(),
);

class ProfileAccountController extends StateNotifier<ProfileAccountState> {
  ProfileAccountController() : super(const ProfileAccountState());

  void setEmail(String v) => state = state.copyWith(email: v);
  void setName(String v) => state = state.copyWith(fullName: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
}
