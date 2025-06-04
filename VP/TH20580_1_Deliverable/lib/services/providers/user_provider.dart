import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';
import '../user_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final UserService _userService = UserService();

  Future<void> fetchUserInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentUser = await _userService.fetchUserInfo();
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}