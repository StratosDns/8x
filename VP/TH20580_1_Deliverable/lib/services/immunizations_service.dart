import '../models/immunization_model.dart';

class ImmunizationsService {
  Future<List<ImmunizationModel>> fetchImmunizations() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      ImmunizationModel(
        date: 'May 2008',
        immunizationName: 'Influenza virus vaccine, IM',
        type: 'Intramuscular injection',
        doseQuantityValue: '50',
        doseQuantityUnit: 'mcg',
        educationInstructions: 'Possible flu-like symptoms for three days',
      ),
      ImmunizationModel(
        date: 'April 2013',
        immunizationName: 'Tetanus and diphtheria toxoids, IM',
        type: 'Intramuscular injection',
        doseQuantityValue: '50',
        doseQuantityUnit: 'mcg',
        educationInstructions: 'Mild pain or soreness in the local area',
      ),
    ];
  }
}