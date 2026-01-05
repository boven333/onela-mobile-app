import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, required super.email});

  factory UserModel.mock(String email) {
    return UserModel(id: DateTime.now().millisecondsSinceEpoch.toString(), email: email);
  }
}
