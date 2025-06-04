import 'package:flutter/foundation.dart';
import '../../models/immunization_model.dart';
import '../immunizations_service.dart';

class ImmunizationsProvider with ChangeNotifier {
  List<ImmunizationModel> _immunizations = [];
  bool _isLoading = false;
  String? _error;

  List<ImmunizationModel> get immunizations => _immunizations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ImmunizationsService _immunizationsService = ImmunizationsService();

  Future<void> fetchImmunizations() async {
    try {
      _isLoading = true;
      notifyListeners();

      _immunizations = await _immunizationsService.fetchImmunizations();
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