import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInEmail {
  final AuthRepository repo;
  SignInEmail(this.repo);

  Future<User> call(String email) => repo.signInWithEmail(email);
}
