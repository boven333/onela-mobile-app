import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInSocial {
  final AuthRepository repo;
  SignInSocial(this.repo);

  Future<User> call(SocialProvider provider) => repo.signInWithSocial(provider);
}
