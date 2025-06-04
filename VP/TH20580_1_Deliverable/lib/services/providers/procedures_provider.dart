import 'package:flutter/foundation.dart';
import '../../models/procedures_model.dart';

import '../procedures_service.dart';


class ProceduresProvider with ChangeNotifier {
  List<ProceduresModel> _procedures = [];
  bool _isLoading = false;
  String? _error;

  List<ProceduresModel> get procedures => _procedures;
  int get proceduresCount => _procedures.length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ProceduresService _proceduresService = ProceduresService();

  Future<void> fetchProcedures() async {
    try {
      _isLoading = true;
      notifyListeners();

      _procedures = await _proceduresService.fetchProcedures();
      print('Procedures count: ${_procedures.length}'); // Debug print
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