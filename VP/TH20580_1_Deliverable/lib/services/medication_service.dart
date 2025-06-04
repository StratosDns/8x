import '../models/medication_model.dart';

class MedicationService {
  Future<List<MedicationModel>> fetchMedications() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      MedicationModel(
        date: 'March 28, 2005',
        type: 'Liquid',
        medicationName: 'Acetaminophen with codeine',
        instructions: '2 puffs once a day',
        doseQuantityValue: '2',
        doseQuantityUnit: 'puffs',
        rateQuantityValue: '1',
        rateQuantityUnit: 'day',
        prescriber: 'Ashby Medical Center',
      ),
      MedicationModel(
        date: 'December 10, 2003',
        type: 'Tablet',
        medicationName: 'Indomethacin',
        instructions: '50mg bid with food',
        doseQuantityValue: '50',
        doseQuantityUnit: 'mg',
        rateQuantityValue: '2',
        rateQuantityUnit: 'day',
        prescriber: 'Ashby Medical Center',
      ),
    ];
  }
}