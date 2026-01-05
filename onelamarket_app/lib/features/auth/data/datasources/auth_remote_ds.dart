import 'dart:async';

import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  Future<UserModel> registerEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return UserModel.mock(email);
  }

  Future<UserModel> signInEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return UserModel.mock(email);
  }

  Future<UserModel> signInSocial(SocialProvider provider) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return UserModel.mock('${provider.name}@mock.onela');
  }
}
