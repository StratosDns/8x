import '../models/procedures_model.dart';

class ProceduresService {
  Future<List<ProceduresModel>> fetchProcedures() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      ProceduresModel(
        procedure: 'Laparoscopic Cholecystectomy',
        date: 'September 28, 2002',
        provider: 'Dr. Antonios Papageorgiou',
        location: 'Ashby Medical Center',
      ),
      ProceduresModel(
        procedure: 'Cesarian Section',
        date: 'March 22, 2002',
        provider: 'Dr. Georgios Papantoniou',
        location: 'Ashby Medical Center',
      ),
    ];
  }
}