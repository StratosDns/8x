import 'package:flutter/foundation.dart';
import '../../models/problem_list_model.dart';
import '../problem_list_service.dart';

class ProblemListProvider with ChangeNotifier {
  List<ProblemListModel> _problemList = [];
  bool _isLoading = false;
  String? _error;

  List<ProblemListModel> get problemList => _problemList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ProblemListService _problemListService = ProblemListService();

  Future<void> fetchProblemList() async {
    try {
      _isLoading = true;
      notifyListeners();

      _problemList = await _problemListService.fetchProblemList();
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