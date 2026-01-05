import '../entities/user.dart';

enum SocialProvider { line, google, facebook }

abstract class AuthRepository {
  Future<User> registerWithEmail(String email);
  Future<User> signInWithEmail(String email);
  Future<User> signInWithSocial(SocialProvider provider);
}
