import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterEmail {
  final AuthRepository repo;
  RegisterEmail(this.repo);

  Future<User> call(String email) => repo.registerWithEmail(email);
}
