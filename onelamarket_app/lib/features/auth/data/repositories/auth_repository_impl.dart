import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_ds.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<User> registerWithEmail(String email) => remote.registerEmail(email);

  @override
  Future<User> signInWithEmail(String email) => remote.signInEmail(email);

  @override
  Future<User> signInWithSocial(SocialProvider provider) => remote.signInSocial(provider);
}
