import '../models/user_model.dart';

class UserService {
  Future<UserModel> fetchUserInfo() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    return UserModel(
      id: 'randomID',
      name: 'Efstratios Demertzoglou',
      profileImagePath: 'assets/images/profile.png',
    );
  }
}