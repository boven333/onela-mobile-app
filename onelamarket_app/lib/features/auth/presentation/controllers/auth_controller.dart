import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/auth_remote_ds.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

// app mode provider (Household/Business)
enum UserMode { household, business }

final userModeProvider = StateProvider<UserMode>((ref) => UserMode.household);

// DI providers
final _authRemoteProvider = Provider<AuthRemoteDataSource>((ref) => AuthRemoteDataSource());
final _authRepoProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(_authRemoteProvider)),
);

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.read(_authRepoProvider)),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repo) : super(AuthState.idle);

  final AuthRepository _repo;

  Future<void> registerEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.registerWithEmail(email);
      state = state.copyWith(isLoading: false, user: user, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'สมัครสมาชิกไม่สำเร็จ');
    }
  }

  Future<void> signInEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.signInWithEmail(email);
      state = state.copyWith(isLoading: false, user: user, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'เข้าสู่ระบบไม่สำเร็จ');
    }
  }

  Future<void> signInSocial(SocialProvider provider) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.signInWithSocial(provider);
      state = state.copyWith(isLoading: false, user: user, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'เข้าสู่ระบบไม่สำเร็จ');
    }
  }

  void reset() => state = AuthState.idle;
}
