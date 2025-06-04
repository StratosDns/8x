import '../models/demographics_model.dart';

class DemographicsService {
  Future<DemographicsModel> fetchDemographics() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return DemographicsModel(
      firstName: 'Efstratios',
      lastName: 'Demertzoglou',
      gender: 'Male',
      maritalStatus: '-',
      religiousAffiliation: '-',
      ethnicity: 'Greek',
      languageSpoken: 'English/Greek',
      address: 'Agiou Mina 13, Irakleio, GR 71201',
      telephone: '6980869076',
      birthday: 'May 16, 2003',
    );
  }
}