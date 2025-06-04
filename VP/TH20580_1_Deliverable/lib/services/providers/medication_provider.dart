import 'package:flutter/foundation.dart';
import '../../models/medication_model.dart';
import '../medication_service.dart';

class MedicationProvider with ChangeNotifier {
  List<MedicationModel> _medications = [];
  bool _isLoading = false;
  String? _error;

  List<MedicationModel> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final MedicationService _medicationService = MedicationService();

  Future<void> fetchMedications() async {
    try {
      _isLoading = true;
      notifyListeners();

      _medications = await _medicationService.fetchMedications();
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